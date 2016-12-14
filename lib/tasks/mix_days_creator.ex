defmodule Mix.Tasks.MixDaysCreator do
  use Mix.Task

  @shortdoc 'Create days for month - [date]'
  def run(_) do
    Janitor.Repo.start_link()
    today = Ecto.Date.utc
    case (today.month + 1) == 13 do
      true ->
        year = (today.year + 1)
        month = 1
      false ->
        yaer = today.year
        month = (today.month + 1)
    end
    date = Ecto.Date.cast!(%{year: year, month: month, day: 1})
    Janitor.CreateDaysForMonth.call(date)
  end
end
