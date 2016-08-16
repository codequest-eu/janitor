defmodule Janitor.DaysChannelSpec do 
  @endpoint Janitor.Endpoint
  use Phoenix.ChannelTest
  import ExUnit.Assertions, only: [assert_receive: 2]
  use Timex
  alias Janitor.DayFactory
  alias Janitor.UserFactory
  alias Janitor.DaysView
  use ESpec.Phoenix, model: Janitor.DaysChannel

  let! :day1, do: DayFactory.create(:day, date: %Ecto.Date{day: 1, month: 2, year: 2016})
  let! :day2, do: DayFactory.create(:day, date: %Ecto.Date{day: 2, month: 2, year: 2016})
  let! :day3, do: DayFactory.create(:day, date: Ecto.Date.utc())
  let! :user, do: UserFactory.create(:user)
  let :token, do: (
    JsonWebToken.sign(%{user_id: user.id, exp: Timex.shift(Date.today, days: 7)},
      %{key: System.get_env("JWT_SECRET")})
  )

  describe "days:update:channel" do 
    let! :socket1, do: (
      {:ok, socket} = connect(Janitor.UserSocket, %{})
      {:ok, _, socket} = subscribe_and_join(socket,Janitor.DaysChannel, "days")
      socket
    )
    it "updates day" do 
      push socket1, "update:day:#{day1.id}", %{token: token, working: true}
      payload = DaysView.render("day.json", day: day1)
      id = day1.id
      assert_broadcast "updated:day:#{id}", payload
    end 
  end 

end 
