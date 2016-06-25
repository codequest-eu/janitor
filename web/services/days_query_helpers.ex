defmodule Janitor.DaysQueryHelpers do 
  import Ecto.Query 

  def from_month(month \\ Ecto.Date.utc().month) do 
    {:ok, start_date} = get_start_date(month)
    {:ok, end_date} = get_end_date(month)
    from d in Janitor.Day, where: d.date >= ^start_date and d.date <= ^end_date
  end 

  defp get_start_date(month) do 
    current_date = Ecto.Date.utc()
    Ecto.Date.cast(%{month: month, year: current_date.year, day: 1})
  end 

  defp get_end_date(month) do 
    current_date = Ecto.Date.utc()
    last_day = :calendar.last_day_of_the_month(current_date.year, month)
    Ecto.Date.cast(%{month: month, year: current_date.year, day: last_day})
  end 
end 
