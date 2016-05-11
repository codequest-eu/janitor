defmodule Janitor.UserTest do 
  use Janitor.ModelCase
  alias Janitor.User

  having "valid changeset" do 
    setup context do 
      assign context, changeset: %{
        first_name: "Mark",
        last_name: "test", 
        google_id: "test1234", 
        email: "test@test.com"
      }
    end 

    should("set valid? to true", context) do 
      changeset = User.registration_changeset(%User{}, context.changeset)
      assert changeset.valid?
    end 
  end 

  having "invalid changeset" do 
    setup context do 
      assign context, changeset: %{
        first_name: "Mark",
        last_name: "test", 
        google_id: "test1234", 
        email: "wrong_email"
      }
    end 

    should("set valid? to false", context) do
      changeset = User.registration_changeset(%User{}, context.changeset)
      is_not changeset.valid?
    end 
  end 
end 