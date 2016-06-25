defmodule Janitor.DaysControllerSpec do
  use ESpec.Phoenix, controller: Janitor.DaysController 
  alias Janitor.DayFactory

  describe "index" do 
    let! :day1, do: DayFactory.create(:day, date: %Ecto.Date{day: 1, month: 2, year: 2016})
    let! :day2, do: DayFactory.create(:day, date: %Ecto.Date{day: 2, month: 2, year: 2016})
    let! :day3, do: DayFactory.create(:day, date: Ecto.Date.utc())

    context "with no params" do 
      let :days_to_json, do: [day1,day2] |> render_days

      subject do: action(:index, %{}, conn)
      it do: should be_successful
      it do: should render_template("days.json")
      it do: should have_in_assigns(days: [day3])
    end

    context "with month param" do 
      subject do: action(:index, %{month: 2}, conn)

      it do: should have_in_assigns(days: [day1,day2])
    end 
  end    
end 
