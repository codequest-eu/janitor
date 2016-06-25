defmodule Janitor.DaysView do
  use Janitor.Web, :view

  def render("days.json", %{days: days}) do
    days |> Enum.map(fn (day) -> 
        day |> Map.from_struct |> Map.take([:id, :date, :working, :user_id])
      end)
  end
end
