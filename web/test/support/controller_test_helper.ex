defmodule Janitor.ControllerTestHelper do
  defmacro __using__(_) do
    quote do
      alias Janitor.{User, Repo}

      def sign_in_as(conn, user) do
        date =  DateTime.utc_now |> Timex.shift(days: 7)
        jwt = JsonWebToken.sign(
          %{user_id: user.id, exp: DateTime.to_unix(date)},
          %{key: System.get_env("JWT_SECRET")})
        conn =
          conn
          |> put_req_header("authorization", "Bearer #{jwt}")
      end
    end
  end
end
