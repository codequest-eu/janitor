defmodule Janitor.TestController do
  use Janitor.Web, :controller
  use Timex

  def index(conn, _params) do
    # check_expiration_time(conn[:claims])
    assign_current_user(conn)
  end

  defp check_expiration_time(conn) do
    claims = conn[:claims]
    if DateTime.today < claims[:exp] do
      send_resp(conn, 403, nil)
    else
      conn
    end
  end

  defp assign_current_user(conn) do
    claims = conn.assigns[:claims]
    case Repo.get!(User, claims[:user_id]) do
      {:ok, user} ->
        IO.puts user
      :error ->
        send_resp(conn, 403, nil)
    end
  end
end
