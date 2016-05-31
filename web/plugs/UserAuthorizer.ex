require IEx
defmodule Janitor.Plugs.UserAuthorizer do
  use Timex
  import Plug.Conn

  def init(_) do
  end

  def call(conn, _) do
    conn
    |> run_unless_error(&verify_token/1)
    |> run_unless_error(&check_expiration_time/1)
    |> run_unless_error(&assign_current_user/1)
    |> end_processing
  end

  #PRIVATE

  defp end_processing(conn) do
    if conn.assigns[:auth_error] do
      send_resp(conn, 403, conn.assigns[:auth_error]) |> Plug.Conn.halt
    else
      conn
    end
  end

  defp run_unless_error(conn, func) do
    if conn.assigns[:auth_error] do
      conn
    else
      func.(conn)
    end
  end

  defp verify_token(conn) do
    token = parse_token(conn)
    case JsonWebToken.verify(token, %{key: System.get_env("JWT_SECRET")}) do
      {:ok, claims} ->
        conn = assign(conn, :claims, claims)
      {:error, "invalid"} ->
        conn = assign(conn, :auth_error, "Unauthorized request")
    end
  end

  defp check_expiration_time(conn) do
    claims = conn.assigns[:claims]
    if Date.today > claims[:exp] do
      conn = assign(conn, :auth_error, "Unauthorized request")
    else
      conn
    end
  end

  defp assign_current_user(conn) do
    claims = conn.assigns[:claims]
    case Repo.get!(User, claims[:user_id]) do
      {:ok, user} ->
        conn = assign(conn, :current_user, user)
      :error ->
        conn = assign(conn, :auth_error, "Unauthorized request")
    end
  end

  defp parse_token(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> List.first |> String.split |> tl |> List.first
  end
end
