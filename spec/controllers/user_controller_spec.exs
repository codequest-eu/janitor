defmodule Janitor.UserControllerSpec do
  use ESpec.Phoenix, controller: Janitor.UserController
  import Janitor.UserFactory

  describe "me" do
    let :user, do: create(:user)
    let :custom_conn, do: assign(conn, :current_user, user)

    subject do:  action(:me, %{}, custom_conn)

    it do: should be_successful
    it do: should render_template("me.json")
    it do: should have_in_assigns(user: user)
  end
end
