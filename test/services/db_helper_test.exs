defmodule Janitor.DBHelpersTest do
  use ExUnit.Case, async: false

  import Janitor.UserFactory
  import Ecto.Query

  alias Janitor.{User, Repo, DBHelpers}

  @valid_params %{
    first_name: "Andrzej",
    last_name: "Schabowy",
    google_id: "123uuid",
    email: "test@gmail.com",
  }

  test "creates new user" do
    changeset = User.registration_changeset(%User{}, @valid_params)
    query = from(u in User, select: count(u.id))
    assert Repo.one(query) == 0
    DBHelpers.find_or_create_by(User, changeset, :google_id)
    assert Repo.one(query) == 1
  end

  test "finds user" do
    changeset = User.registration_changeset(%User{}, @valid_params)
    Repo.insert(changeset)
    user = Repo.get_by(User, @valid_params)
    assert DBHelpers.find_or_create_by(User, changeset, :google_id) == {:ok, user}
  end

  test "does not create new user" do
    changeset = User.registration_changeset(%User{}, @valid_params)
    Repo.insert(changeset)
    query = query = from(u in User, select: count(u.id))
    users_count = Repo.one(query)
    DBHelpers.find_or_create_by(User, changeset, :google_id)
    assert Repo.one(query) == users_count
  end
end
