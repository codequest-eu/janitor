defmodule Janitor.UserViewsSpec do
  use ESpec.Phoenix, view: Janitor.UserView
  import Janitor.UserFactory
  alias Janitor.User

  describe "me" do
    let :user, do: create(:user)
    let :user_to_json, do: Map.take(user, [:first_name, :last_name, :email])
    subject do: render("me.json", user: user)

    it do: should eq(Poison.encode!(user_to_json))
  end
end
