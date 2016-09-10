defmodule Janitor.DateManipulation do

  def get_start_date_for_month_in(date) do
    Ecto.Date.cast(%{month: date.month, year: date.year, day: 1})
  end

  def get_end_date_for_month_in(date) do
    month = date.month
    year = date.year
    last_day = :calendar.last_day_of_the_month(year, month)
    Ecto.Date.cast(%{month: month, year: year, day: last_day})
  end

end
