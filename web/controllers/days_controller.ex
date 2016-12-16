defmodule Janitor.DaysController do
  use Janitor.Web, :controller
  import Janitor.DaysQueryHelpers
  alias Janitor.Repo
  alias Janitor.Day

  def index(conn, %{"month" => month}) do
    days = Repo.all(from_month(month))
    render conn, "days.json", days: days
  end

  def show(conn, %{"id" => id}) do
    day = Repo.get(Day, id) |> Repo.preload(:user)
    render conn, "day.json", day: day
  end

  def index(conn, _) do
    days = Repo.all(from_month())
    render conn, "days.json", days: days
  end
end
