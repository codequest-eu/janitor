defmodule Janitor.UserViewsSpec do
  use ESpec.Phoenix, view: Janitor.UserView
  import Janitor.UserFactory
  alias Janitor.User

  describe "me" do
    let :user, do: create(:user)
    let :user_to_json do
      user
      |> Map.take([:first_name, :last_name, :email])
      |> Poison.encode!
    end
    subject do: render("me.json", user: user)

    it do: should eq(user_to_json)
  end
end
