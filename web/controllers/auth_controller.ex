require IEx
defmodule Janitor.AuthController do
  use Janitor.Web, :controller
  alias Janitor.User 

  def connect(conn, _params) do
    redirect conn, external: Google.authorize_url!(scope: "email profile")
  end

  def oauth(conn, %{"code" => code}) do 
    params = token(code) |> get_user! |> map_params
    changeset = User.registration_changeset(%User{}, params)
    User.find_or_create(changeset)    
  end 

  defp token(token_string) do
     Google.get_token!(code: token_string)
  end

  defp get_user!(token) do
    user_url = "https://www.googleapis.com/plus/v1/people/me"
    OAuth2.AccessToken.get!(token, user_url)
  end

  defp find_or_create(changeset) do 
    Repo.get_by(User, google_id: changeset["google_id"]) 
  end 

  defp map_params(data) do 
    %{body: %{"emails" => [%{"value" => email}], "displayName" => name, "id" => id}} = data
    [first_name, last_name] = String.split(name)
    %{email: email, google_id: id, first_name: first_name, last_name: last_name}
  end 
end
