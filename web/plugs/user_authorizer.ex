defmodule Janitor.Plugs.UserAuthorizer do
  use Timex
  import Plug.Conn

  alias Janitor.User
  alias Janitor.Repo

  def init(_) do
  end

  def call(conn, _) do
    perform_checks(
      {conn, nil},
      [
        &extract_token_claims/1,
        &check_expiration_time/1,
        &assign_current_user/1
      ]
    )
  end

  #PRIVATE

  defp perform_checks({conn, nil}, []), do: end_processing(conn, nil)
  defp perform_checks({conn, nil}, [check_fun | remaining_checks]) do
    perform_checks(check_fun.(conn), remaining_checks)
  end
  defp perform_checks({conn, err}, _), do: end_processing(conn, err)

  defp end_processing(conn, err) do
    case err do
      nil -> conn
      _ -> conn |> send_resp(403, "Unauthorized request") |> Plug.Conn.halt
    end
  end

  defp extract_token_claims(conn) do
    case parse_and_verify_token(conn) do
      {:ok, claims} ->
        conn = assign(conn, :claims, claims)
        {conn, nil}
      {:error, _} ->
        {conn, :error}
    end
  end

  defp check_expiration_time(conn) do
    claims = conn.assigns.claims
    cond do
      Map.from_struct(DateTime.now) > claims.exp ->
        {conn, :error}
      true -> {conn, nil}
    end
  end

  defp assign_current_user(conn) do
    claims = conn.assigns.claims
    try do
      user = Repo.get!(User, claims.user_id)
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
    |> List.first |> String.split |> tl |> List.first
    |> JsonWebToken.verify(%{key: System.get_env("JWT_SECRET")})
  end
end
