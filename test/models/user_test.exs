defmodule Janitor.UserTest do
  use Janitor.ModelCase
  use ExUnit.Case, async: true

  alias Janitor.User
  alias Janitor.UserFactory

  test "changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, UserFactory.fields_for(:user))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "returns email error message (presence)" do
    changeset = User.registration_changeset(%User{}, %{})
    assert changeset.errors[:email] == "can't be blank"
  end

   test "returns email error message (format)" do
    changeset = User.registration_changeset(%User{}, %{email: "a"})
    assert changeset.errors[:email] == "has invalid format"
  end
end
