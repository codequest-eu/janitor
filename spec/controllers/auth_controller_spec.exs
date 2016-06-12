defmodule Janitor.AuthControllerSpec do
  alias Janitor.Google
  import Janitor.Factory
  use ESpec.Phoenix, controller: Janitor.AuthController 

  describe "connect" do 
    subject do: action(:connect)

    it do: should redirect_to(Google.authorize_url!(scope: "email profile"))
  end 

  describe "oauth" do 
    subject do: action(:oauth, %{"code" => "some_code"})

    before do
      allow(Google).to(accept(:get_token!, fn (_) -> "some_token" end))
      allow(OAuth2.AccessToken).to(accept(:get!, fn (_,_) 
        -> build(:google_plus_user)
      end))
      allow(JsonWebToken).to accept(:sign, fn (_,_) -> "some_token" end )
    end 

    it do: should have_http_status(302)
    it do: should redirect_to "http://localhost:5000?token=some_token"
  
  end 
end 