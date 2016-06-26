defmodule Janitor.DaysController do
  use Janitor.Web, :controller
  import Janitor.DaysQueryHelpers
  alias Janitor.Repo

  def index(conn, %{"month" => month}) do 
    days = Repo.all(from_month(month))
    render conn, days: days
  end 

  def index(conn, _) do 
    days = Repo.all(from_month())
    render conn, days: days
  end 
end
