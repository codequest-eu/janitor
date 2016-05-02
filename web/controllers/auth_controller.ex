require IEx
defmodule Janitor.AuthController do
  use Janitor.Web, :controller
  use OAuth2.Strategy

  def connect(conn, _params) do
    redirect conn, external: authorize_url!()
  end

  def oauth(_conn, _params) do 
    IEx.pry
  end 

  defp client do 
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode, #default
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      site: "https://accounts.google.com",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      redirect_uri: "http://localhost:4567/oauth",
      token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
    ])
  end 

  defp authorize_url!(params \\ []) do
    client()
    |> put_param(:scope, "email profile")
    |> OAuth2.Client.authorize_url!(params)
  end
end
