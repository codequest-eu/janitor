defmodule Janitor.Router do
  use Janitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Janitor do
    pipe_through :browser # Use the default browser stack

    get "/connect", AuthController, :connect
    get "/oauth", AuthController, :oauth
  end

  # Other scopes may use custom stacks.
  # scope "/api", Janitor do
  #   pipe_through :api
  # end
end
