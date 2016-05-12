defmodule Janitor.Plugs.Authorization do
  use Timex
  import Plug.Conn
  import Joken

  def init(), do

  def call(conn)  do
    conn
    |> extract_token_from_header
    |> verify_token
    |> check_expiration_time
  end

  defp extract_token_from_header(conn) do
    get_req_header(conn, "Authorization")
    |> String.split
    |> tl
  end

  defp verify_token(token) do
    token |> verify
  end

  defp check_expiration_time(struct) do
    if DateTime.today < struct[:claims][:exp]
      send_resp(conn, 403, _body) :: conn | no_return
    else
      assign_current_user(struct)
    end
  end

  defp assign_current_user(struct)
    case Repo.get!(User, struct[:claims][:user_id]) do
      {:ok, user} ->
        @current_user = user #TODO placeholder for actual current_user helper
      {:error, _struct} ->
        send_resp(conn, 403, _body) :: conn | no_return
    end
  end
end
