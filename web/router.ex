require IEx
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

    get "/", TestController, :index
  end

  def authenticate_request(conn, _) do
    token = parse_token(conn)
    claims = JsonWebToken.verify(token, %{alg: "none"})
    assign_claims_to_conn(conn, claims)
    # |> check_expiration_time(conn)
  end

  defp assign_claims_to_conn(conn, {:ok, claims}) do
    assign(conn, :claims, claims)
  end

  defp assign_claims_to_conn(conn, {:error}) do
    send_resp(conn, 403, nil)
  end

  defp parse_token(conn) do
    get_req_header(conn, "authorization")
    |> List.first
    |> String.split
    |> tl |> List.first
  end
end
