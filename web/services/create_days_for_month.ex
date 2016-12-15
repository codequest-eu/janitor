defmodule Janitor.CreateDaysForMonth do
  alias Janitor.Repo
  alias Janitor.Day
  import Janitor.DateManipulation

  def call(date) do
    {:ok, start_date} = get_start_date_for_month_in(date)
    {:ok, end_date} = get_end_date_for_month_in(date)
    IO.puts "ENUM: #{Enum.to_list(start_date.day..end_date.day)}"
    create_days(Enum.to_list(start_date.day..end_date.day), date)
  end

  #private

  defp create_days([head | tail], date) do
    create_day(head, date)
    create_days(tail, date)
  end
  defp create_days([], date) do
    IO.puts "I na tym zakończymy!"
  end

  defp create_day(day_number, date) do
    {:ok, iterated_date} = create_date(day_number, date)
    params = %{date: iterated_date, working: is_working(iterated_date)}
    day = Day.changeset(%Day{}, params)
    Repo.insert day
  end

  defp is_working(date) do
    day_of_the_week = :calendar.day_of_the_week(Ecto.Date.to_erl(date))
    !Enum.member?([6,7], day_of_the_week)
  end

  defp create_date(day_number, date) do
    Ecto.Date.cast(%{month: date.month, year: date.year, day: day_number})
  end
end
