defmodule Janitor.DaysView do
  use Janitor.Web, :view

  @day_fields [:id, :date, :working, :user_id]

  def render("days.json", %{days: days}) do
    Enum.map(days, fn (day) ->
      day
        |> pick_fields(@day_fields)
        |> Map.put(:user, render_user(day))
    end)
  end

  def render("days_with_tasks.json", %{days: days}) do
    Enum.map(days, fn (day) ->
      day
        |> pick_fields(@day_fields)
        |> Map.put(:user, render_user(day))
        |> Map.put(:tasks, Janitor.TaskView.render("index.json", %{tasks: day.tasks}))
    end)
  end

  def render("day.json", %{day: day}) do
    render_day day
  end

  defp render_day(day) do
    day
      |> Map.from_struct
      |> Map.take(@day_fields)
      |> Map.put(:user, render_user(day))
  end

  def render_user(day) do
    case day.user do
      nil -> nil
      _ -> Janitor.UserView.render("me.json", %{user: day.user})
    end
  end
end
