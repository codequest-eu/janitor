defmodule Janitor.DaysViewsSpec do
  use ESpec.Phoenix, view: Janitor.DaysView
  alias Janitor.DayFactory
  alias Janitor.Day

  def render_days(days) do 
    days |> Enum.map(
      fn (day) -> 
        day |> Map.from_struct |> Map.take([:id, :date, :working, :user_id])
      end
    ) |> Poison.encode! 
  end 

  describe "days" do
    let! :day1, do: DayFactory.create(:day, date: %Ecto.Date{day: 1, month: 2, year: 2016})
    let! :day2, do: DayFactory.create(:day, date: %Ecto.Date{day: 2, month: 2, year: 2016})

    let :days_to_json do
      [day1,day2] |> render_days
    end

    subject do: render("days.json", days: [day1, day2])

    it do: should eq(days_to_json)
  end
end
