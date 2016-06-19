defmodule Janitor.DayFactory do
  use ExMachina.Ecto, repo: Janitor.Repo
  alias Janitor.UserFactory

  def factory(:day) do 
    date = %Ecto.DateTime{day: 1, month: 2, year: 2016}
    %Janitor.Day{working: false, date: date, user: UserFactory.build(:user)}
  end 

  def factory(:invalid_day) do
    %Janitor.Day{date: nil}
  end 
end 
