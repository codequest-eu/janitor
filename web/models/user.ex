defmodule Janitor.User do
  use Janitor.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :google_id, :string

    has_many :days, Janitor.Day
    
    timestamps
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(first_name email google_id), ~w(last_name))
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
  end
end
