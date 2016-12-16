defmodule Janitor.DaysView do
  use Janitor.Web, :view

  def render("days.json", %{days: days}) do
    Enum.map(days, fn (day) ->
      day
        |> pick_fields([:id, :date, :working, :user_id])
        |> Map.put(:user, render_user(day))
    end)
  end

  def render("day.json", %{day: day}) do
    render_day day
  end

  defp render_day(day) do
    day
      |> Map.from_struct
      |> Map.take([:id, :date, :working, :user_id])
      |> Map.put(:user, render_user(day))
  end

  def render_user(day) do
    case day.user do
      nil -> nil
      _ -> Janitor.UserView.render("me.json", %{user: day.user})
    end
  end
end
