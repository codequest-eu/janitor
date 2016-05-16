
defmodule Janitor.Router do
  use Janitor.Web, :router
  import Plug.Conn

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :authenticate_request
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

  def authenticate_request(conn, _) do
    parse_token(conn)
    |> verify_token(conn)
    |> check_expiration_time(conn)
    |> assign_current_user(conn)
  end

  # PRIVATE

  defp parse_token(conn) do
    conn
    |> get_req_header("authorization")
    |> List.first
    |> String.split
    |> tl |> List.first
  end

  defp verify_token(token, conn) do
    case JsonWebToken.verify(token, %{key: System.get_env("JWT_SECRET")}) do
      {:ok, claims} ->
        claims
      {:error, "invalid"} ->
        send_403(conn)
    end
  end

  defp check_expiration_time(claims, conn) do
    if DateTime.today > claims[:exp] do
      send_403(conn)
    else
      claims[:user_id]
    end
  end

  defp assign_current_user(user_id, conn) do
    case Repo.get!(User, user_id) do
      {:ok, user} ->
        assign(conn, :current_user, user)
      :error ->
        send_403(conn)
    end
  end

  defp send_403(conn) do
    send_resp(conn, 403, "unauthorized") |> halt
  end
end
