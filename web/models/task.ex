defmodule Janitor.Task do
  use Janitor.Web, :model

  schema "tasks" do
    field :content, :string
    field :done, :boolean
    field :default, :boolean

    belongs_to :user, Janitor.User, foreign_key: :user_id
    belongs_to :day, Janitor.Day, foreign_key: :day_id
    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(content day_id), ~w(user_id default done))
  end
end
