require IEx
defmodule Janitor.AuthController do
  use Janitor.Web, :controller

  def connect(conn, _params) do
    redirect conn, external: Google.authorize_url!(scope: "email profile")
  end

  def oauth(conn, %{"code" => code}) do 
    t = token(code)
    IO.inspect t
    user = get_user!(t)
    IEx.pry
    redirect conn, external: "http://localhost:5080"
  end 

  defp token(token_string) do
     Google.get_token!(code: token_string)
  end

  defp get_user!(token) do
    user_url = "https://www.googleapis.com/plus/v3/people/me/openIdConnect"
    OAuth2.AccessToken.get!(token, user_url)
  end
end
