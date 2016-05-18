require IEx
defmodule Janitor.Router do
  use Janitor.Web, :router
  use Timex
  import Plug.Conn


  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :verify_token
    plug :check_expiration_time
    plug :assign_current_user
  end

  scope "/", Janitor do
    pipe_through :browser

    get "/connect", AuthController, :connect
    get "/oauth", AuthController, :oauth
  end

  scope "/api", Janitor do
    pipe_through :api
    get "/test", TestController, :index
  end

  def verify_token(conn, _) do
    token = parse_token(conn)
    case JsonWebToken.verify(token, %{key: System.get_env("JWT_SECRET")}) do
      {:ok, claims} ->
        conn = assign(conn, :claims, claims)
      {:error, "invalid"} ->
        unauthorized(conn) |> halt
    end
  end

  defp parse_token(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first |> String.split |> tl |> List.first
  end

  def check_expiration_time(conn, _) do
    claims = conn.assigns[:claims]
    if Date.today > claims[:exp] do
      unauthorized(conn) |> halt
    else
      conn
    end
  end

  def assign_current_user(conn, _) do
    claims = conn.assigns[:claims]
    case Repo.get!(User, claims[:user_id]) do
      {:ok, user} ->
        conn = assign(conn, :current_user, user)
      :error ->
        unauthorized(conn) |> halt
    end
  end

  defp unauthorized(conn) do
    send_resp(conn, 403, "Unauthorized request")
  end
end
