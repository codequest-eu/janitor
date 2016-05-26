require IEx
defmodule Janitor.Plugs.JWTVerifier do
  use Timex
  import Plug.Conn

  def init(_) do
  end

  def call(conn, _) do
    verified_token =
      with {:ok, conn} <- verify_token(conn),
        {:ok, conn} <- check_expiration_time(conn),
        {:ok, conn} <- assign_current_user(conn),
      do: {:ok, conn}
    case verified_token do
      {:ok, conn} -> conn
      {:error, message} -> send_resp(conn, 403, message) |> Plug.Conn.halt
    end
  end

  def verify_token(conn) do
    token = parse_token(conn)
    case JsonWebToken.verify(token, %{key: System.get_env("JWT_SECRET")}) do
      {:ok, claims} ->
        conn = assign(conn, :claims, claims)
      {:error, "invalid"} ->
        {:error, "Unauthorized request"}
    end
  end

  def check_expiration_time(conn) do
    claims = conn.assigns[:claims]
    if Date.today > claims[:exp] do
      {:error, "Unauthorized request"}
    else
      conn
    end
  end

  def assign_current_user(conn) do
    claims = conn.assigns[:claims]
    case Repo.get!(User, claims[:user_id]) do
      {:ok, user} ->
        conn = assign(conn, :current_user, user)
      :error ->
        {:error, "Unauthorized request"}
    end
  end

  defp parse_token(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> List.first |> String.split |> tl |> List.first
  end
end
