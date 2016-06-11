defmodule Janitor.UserSpec do 
  import Ecto.Query
  use ESpec.Phoenix, model: Janitor.User
  alias Janitor.User

  let :changeset, do: User.registration_changeset(%User{}, %{
    first_name: "Mark",
    last_name: "test", 
    google_id: "test1234", 
    email: "test@test.com"
  })

  describe "validation" do 
    context "valid changeset" do 
      it "set valid? to true" do 
        expect(changeset.valid?).to eq true
      end 
    end 

    context "invalid changeset" do 
      let :changeset, do: User.registration_changeset(%User{}, %{
        first_name: "Mark",
        last_name: "test", 
        google_id: "test1234", 
        email: "wrong_email"
      })

      it "sets valid? to false" do 
        expect(changeset.valid?).to eq false
      end 

      it "applies email error message" do 
        changeset.valid?
        expect(changeset.errors[:email]).to_not eq nil
      end 
    end 
  end 
end 