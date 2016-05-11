defmodule Janitor.User do
  use Janitor.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :google_id, :string
    timestamps
  end

  def registration_changeset(model, params \\ :empty) do 
    model
    |> cast(params, ~w(first_name email google_id), ~w(last_name))
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end 

  def find_or_create(changeset) do 
    Repo.get_by(User, google_id: changeset["google_id"]) |> on_find
  end 

  defp on_find({:ok, user}) do 
    user
  end 

  defp on_find({:error, changeset}) do 
    {:ok, user} = Repo.insert(changeset)
  end 
end