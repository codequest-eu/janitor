defmodule Janitor.DayTest do
  use Janitor.ModelCase
  use ExUnit.Case, async: true

  alias Janitor.Day

  @valid_attrs %{
    date: %Ecto.Date{day: 1, month: 2, year: 2016},
    working: true,
  }

  test "changeset with valid attributes" do
    changeset = Day.changeset(%Day{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Day.changeset(%Day{}, %{})
    refute changeset.valid?
  end

  test "returns date error message" do
    changeset = Day.changeset(%Day{}, %{})
    assert changeset.errors[:date] == "can't be blank"
  end
end
