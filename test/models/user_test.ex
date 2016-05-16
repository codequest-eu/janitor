defmodule Janitor.UserTest do 
  use Janitor.ModelCase
  alias Janitor.User

  describe 'validation' do 
    context "valid changeset" do 
      let :changeset, do: User.registration_changeset(%User{}, %{
          first_name: "Mark",
          last_name: "test", 
          google_id: "test1234", 
          email: "test@test.com"
        })
      
      it "set valid? to true" do 
        expect(changeset.valid?).to eq true
      end 
    end 

    # context "invalid changeset" do 
    #   setup context do 
    #     changeset = User.registration_changeset(%User{}, %{
    #       first_name: "Mark",
    #       last_name: "test", 
    #       google_id: "test1234", 
    #       email: "wrong_email"
    #     })
    #     assign context, changeset: changeset
    #   end 

    #   should("set valid? to false", context) do
    #     is_not context.changeset.valid?
    #   end
    #   should("have email in errors", context) do 
    #     # IO.inspect(expect(context.changeset.errors[:email]))
    #     assert context.changeset.errors[:email] == "has invalid format""
    #   end 
    # end 
  # end 
end 