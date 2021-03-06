defmodule Janitor.DaysController do
  use Janitor.Web, :controller
  import Janitor.DaysQueryHelpers
  alias Janitor.Repo
  alias Janitor.Day

  def index(conn, %{"month" => month}) do
    days = month |> from_month |> Repo.all
    render conn, "days.json", days: days
  end

  def index(conn, _) do
    days = Repo.all(from_month())
    conn |> render("days.json", days: days)
  end

  def show(conn, %{"id" => id}) do
    day = Day |> Repo.get(id) |> Repo.preload(:user)
    render conn, "day.json", day: day
  end
end
