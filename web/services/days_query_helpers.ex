defmodule Janitor.DaysQueryHelpers do
  import Ecto.Query
  import Janitor.DateManipulation

  def from_month(date \\ Ecto.Date.utc()) do
    {:ok, start_date} = get_start_date_for_month_in(date)
    {:ok, end_date} = get_end_date_for_month_in(date)
    from d in Janitor.Day, where: d.date >= ^start_date and d.date <= ^end_date
  end

end
