defmodule Janitor.Plugs.UserAuthorizer do
  use Timex
  import Plug.Conn

  alias Janitor.{User, Repo}

  def init(opts), do: opts

  def call(conn, _) do
    case get_req_header(conn, "authorization") do
      [] ->
        send_unauthorized_response(conn)
      _ ->
        perform_checks(
          {conn, nil},
          [
            &extract_token_claims/1,
            &check_expiration_time/1,
            &assign_current_user/1
          ]
        )
    end
  end

  #PRIVATE

  defp perform_checks({conn, nil}, []), do: conn
  defp perform_checks({conn, nil}, [check_fun | remaining_checks]) do
    perform_checks(check_fun.(conn), remaining_checks)
  end
  defp perform_checks({conn, _}, _) do
    send_unauthorized_response(conn)
  end

  defp send_unauthorized_response(conn) do
    defaults = %{errors: "Unauthorized"}
    {:ok, json_body} =
      defaults
      |> Poison.encode

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(403, json_body)
    |> halt
  end

  defp extract_token_claims(conn) do
    case parse_and_verify_token(conn) do
      {:ok, claims} ->
        IO.inspect "LOOOOL"
        IO.inspect claims
        conn = assign(conn, :claims, claims)
        {conn, nil}
      {:error, conn} ->
        {conn, :error}
    end
  end

  defp check_expiration_time(conn) do
    claims = conn.assigns.claims
    if DateTime.to_unix(DateTime.utc_now) > claims.exp do
      {conn, :error}
    else
      {conn, nil}
    end
  end

  defp assign_current_user(conn) do
    claims = conn.assigns.claims
    try do
      user = Repo.get(User, claims.user_id)
      conn = assign(conn, :current_user, user)
      {conn, nil}
    rescue
      Ecto.NoResultsError ->
        {conn, :error}
    end
  end

  defp parse_and_verify_token(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> List.first |> String.split |> List.last
    |> JsonWebToken.verify(%{key: System.get_env("JWT_SECRET")})
  end
end
