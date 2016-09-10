defmodule Janitor.CreateDaysForMonthSpec do
  use ESpec.Phoenix, model: Janitor.CreateDaysForMonth
  import Janitor.DateManipulation
  alias Janitor.CreateDaysForMonth

  describe "call" do
    let :tested_date, do: Ecto.Date.utc()
    subject do: CreateDaysForMonth.call(tested_date)

    it "creates as many Day rows as passed month has" do
      days_count = get_end_date_for_month_in(tested_date)
      expect subject |> to(change(
        fn -> Repo.one(from p in Day, select: count("*")) end,
        0 ,days_count)
      )
    end
  end

end
