defmodule Janitor.AuthControllerSpec do
  alias Janitor.Google
  import Janitor.UserFactory
  use ESpec.Phoenix, controller: Janitor.AuthController 

  describe "connect" do 
    subject do: action(:connect)

    it do: should redirect_to(Google.authorize_url!(scope: "email profile"))
  end 

  describe "oauth" do 
    let :jwt_token, do: "some_token"
    subject do: action(:oauth, %{"code" => "some_code"})

    before do
      allow(Google).to(accept(:get_token!, fn (_) -> "some_token" end))
      allow(OAuth2.AccessToken).to(accept(:get!, fn (_,_) 
        -> build(:google_plus_user)
      end))
      allow(JsonWebToken).to accept(:sign, fn (_,_) -> jwt_token end )
    end 

    it do: should have_http_status(302)
    it do: should redirect_to "#{System.get_env("CLIENT_URL")}?token=#{jwt_token}"
  
  end 
end 
