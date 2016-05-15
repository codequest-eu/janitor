defmodule Janitor.User do
  use Janitor.Web, :model
  alias Janitor.Repo

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
    Repo.get_by(__MODULE__, google_id: changeset.params["google_id"]) 
    |> on_find(changeset)
  end 

  defp on_find(nil, changeset) do 
    {:ok, user} = Repo.insert(changeset)
    user
  end 
  
  defp on_find(%__MODULE__{} = user, changeset) do
    user
  end 
end