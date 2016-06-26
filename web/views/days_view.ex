defmodule Janitor.DaysView do
  use Janitor.Web, :view

  def render(%{days: days}) do
    Enum.map(days, fn (day) -> 
      day |> pick_fields([:id, :date, :working, :user_id]) 
    end)
  end

end
