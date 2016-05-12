defmodule Janitor.Router do
  use Janitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Janitor.Plugs.Authorization
  end

  scope "/", Janitor do
    pipe_through :browser

    get "/connect", AuthController, :connect
    get "/oauth", AuthController, :oauth
  end


  scope "/api", Janitor do
    pipe_through :api
  end

  defp authenticate_request do
  end
end
