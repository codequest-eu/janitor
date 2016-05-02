defmodule Janitor.User do
  use Janitor.Web, :model
  import Ecto.Query

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :google_id, :string
  end


end