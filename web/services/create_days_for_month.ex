defmodule Janitor.CreateDaysForMonth do
  alias Janitor.Repo
  alias Janitor.Day
  alias Janitor.Task
  import Janitor.DateManipulation

  @default_tasks [
    "Setup that motherfuckn dishwasher",
    "Clean that motherfuckn table",
    "Throw that motherfuckn trash",
    "Clean that motherfuckn coffeemachine",
    "Put that motherfuckn milk into fridge"
  ]

  def call(date) do
    {:ok, start_date} = get_start_date_for_month_in(date)
    {:ok, end_date} = get_end_date_for_month_in(date)
    Repo.transaction fn ->
      create_days(Enum.to_list(start_date.day..end_date.day), date)
    end
  end

  #private

  defp create_days([head | tail], date) do
    create_day(head, date)
    create_days(tail, date)
  end
  defp create_days([], _) do
    IO.puts "I na tym zakończymy!"
  end

  defp create_day(day_number, date) do
    {:ok, iterated_date} = create_date(day_number, date)
    params = %{date: iterated_date, working: is_working(iterated_date)}
    day = Day.changeset(%Day{}, params)
    case Repo.insert day do
      {:ok, day} ->
        @default_tasks |> Enum.each(fn(task_text) ->
          task = Task.changeset(%Task{}, %{day_id: day.id, content: task_text, default: true})
          Repo.insert(task)
        end)
      {:error, _} -> raise "Can't insert day!"
    end
  end

  defp is_working(date) do
    day_of_the_week = :calendar.day_of_the_week(Ecto.Date.to_erl(date))
    !Enum.member?([6,7], day_of_the_week)
  end

  defp create_date(day_number, date) do
    Ecto.Date.cast(%{month: date.month, year: date.year, day: day_number})
  end
end
