defmodule Janitor.AuthControllerTest do
  use Janitor.ConnCase, async: true
  use Janitor.Support.ControllerTestHelpers, async: true
  use Timex

  alias Janitor.UserFactory

  describe "me" do
    test "returns status 403", %{conn: conn} do
      response =
        conn
        |> send_me_request(403)
      assert response["errors"] == "Unauthorized"
    end

    test "gets me", %{conn: conn} do
      user = UserFactory.create(:user)
      response =
        sign_in_as(conn, user)
        |> send_me_request(200)

      assert response["email"] == "test0@test.com"
      assert response["first_name"] == "Mark"
      assert response["last_name"] == "test"
    end
  end

  # PRIVATE

  defp send_me_request(conn, status) do
    conn
    |> get(me_path(conn, :me))
    |> json_response(status)
  end
end
