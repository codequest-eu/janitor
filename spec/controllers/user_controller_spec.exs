defmodule Janitor.UserControllerSpec do
  use ESpec.Phoenix, controller: Janitor.UserController
  alias Janitor.User

  describe "show" do
    let :user, do: %User{id: 1, first_name: "John", last_name: "Doe", email: "john@doe.com"}

    before do
      allow Repo |> to accept(:get, fn
        User, 1 -> user
        User, id -> passthrough([id])
      end)
    end

    subject do: action(:me)

    it do: should be_successful
    it do: should render_template("me.json")
    it do: should have_in_assigns(user: user)
  end
end
