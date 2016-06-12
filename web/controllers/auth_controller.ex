defmodule Janitor.AuthController do
  import Janitor.DBHelpers
  use Janitor.Web, :controller
  use Timex
  import DBHelpers
  alias Janitor.User
  alias Janitor.Google
  
  def connect(conn, _params) do
    redirect conn, external: Google.authorize_url!(scope: "email profile")
  end

  def oauth(conn, %{"code" => code}) do
    params = token(code) |> get_user! |> map_params
    changeset = User.registration_changeset(%User{}, params)
    token = find_or_create_by(User, changeset, :google_id) |> sign_jwt_token
    redirect conn, external: "http://localhost:5000?token=#{token}"
  end

  defp sign_jwt_token({:ok, user}) do
    JsonWebToken.sign(
      %{user_id: user.id, exp: Timex.shift(Date.today, days: 7)},
      %{key: System.get_env("JWT_SECRET")})
  end

  defp token(token_string) do
    Google.get_token!(code: token_string)
  end

  defp get_user!(token) do
    user_url = "https://www.googleapis.com/plus/v1/people/me"
    OAuth2.AccessToken.get!(token, user_url)
  end

  defp map_params(data) do
    %{body: %{"emails" => [%{"value" => email}], "displayName" => name, "id" => id}} = data
    [first_name, last_name] = String.split(name)
    %{email: email, google_id: id, first_name: first_name, last_name: last_name}
  end
end
