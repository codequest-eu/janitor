defmodule Janitor.UserSpec do 
  import Ecto.Query
  use ESpec.Phoenix, model: App.User
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

  describe ".find_or_create" do 
    context "when user is not in the database" do
      let! :user, do: User.find_or_create(changeset)
      
      it "inserts user to DB" do 
        query = from(p in User, select: count(p.id))
        expect(Repo.one(query)).to eq 1
      end 

      it "returns new user" do
        expect(user.id).to_not eq nil
      end 
    end 

    context "when user is already in DB" do 
      let! :user, do: User.find_or_create(changeset)

      it "returns the user" do
        expect(User.find_or_create(changeset).id).to eq user.id
      end 

      it "does not change count of objects" do 
        query = from(p in User, select: count(p.id))
        expect(Repo.one(query)).to eq 1
      end 
    end 
  end 
end 