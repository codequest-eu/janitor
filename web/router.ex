defmodule Janitor.Router do
  use Janitor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Janitor.Plugs.UserAuthorizer
  end

  scope "/", Janitor do
    pipe_through :browser

    get "/connect", AuthController, :connect
    get "/oauth", AuthController, :oauth
  end

  scope "/api", Janitor do
    pipe_through :api

    scope "/days" do
      get "/:day_id/tasks", TaskController, :index
      post "/:day_id/tasks", TaskController, :create, as: :create_task
      patch "/:day_id/tasks/:id", TaskController, :update, as: :update_task
      delete "/:day_id/tasks/:id", TaskController, :destroy, as: :destroy_task
    end

    scope "/users", Users do
      get "/:user_id/days", DaysController, :index
    end

    get "/me", UserController, :me, as: :me
    resources "/days", DaysController, only: [:index, :show]

  end
end
