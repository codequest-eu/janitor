defmodule Mix.Tasks.MixDaysCreator do
  use Mix.Task

  @shortdoc 'Create days for month - [date]'
  def run(_) do
    IO.puts "START"
    Janitor.Repo.start_link()
    today = Ecto.Date.utc
    {month, year} = case (today.month + 1) == 13 do
      true -> {1, (today.year + 1)}
      false -> {(today.month + 1), today.year}
    end
    date = Ecto.Date.cast!(%{year: year, month: month, day: 1})
    Janitor.CreateDaysForMonth.call(date)
  end
end
