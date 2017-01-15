defmodule Janitor.Users.DaysController do
  use Janitor.Web, :controller
  import Ecto.Query
  alias Janitor.Repo
  alias Janitor.Day

  plug :put_view, Janitor.DaysView

  def index(conn, %{"user_id" => user_id}) do
    days = Repo.all(from day in Day, where: [user_id: ^user_id], preload: [:tasks, :user])
    conn
      |> render "days_with_tasks.json", days: days
  end
end
