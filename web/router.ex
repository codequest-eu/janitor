defmodule Janitor.Router do
  use Janitor.Web, :router
  use Timex
  import Plug.Conn
  import Joken

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

    get "/", TestController, :index
  end

  def authenticate_request(conn, header_key) do
    get_req_header(conn, %{header_key: "Authorization"}) |> String.split |> tl |> verify
    |> check_expiration_time(conn)
  end

  defp check_expiration_time(conn, struct) do
    if DateTime.today < struct[:claims][:exp] do
      send_resp(conn, 403, struct)
    else
      assign_current_user(conn, struct)
    end
  end

  defp assign_current_user(conn, struct) do
    case Repo.get!(User, struct[:claims][:user_id]) do
      {:ok, user} ->
        user
        #@current_user = user
      :error ->
        send_resp(conn, 403, struct)
    end
  end
end
