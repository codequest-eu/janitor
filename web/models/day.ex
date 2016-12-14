defmodule Janitor.Day do
  use Janitor.Web, :model

  schema "days" do
    field :working, :boolean
    field :date, Ecto.Date

    belongs_to :user, Janitor.User
    has_many :tasks, Janitor.Task

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(date), ~w(working user_id))
  end
end
