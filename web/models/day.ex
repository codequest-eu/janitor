defmodule Janitor.Day do
  use Janitor.Web, :model

  schema "days" do
    field :working, :boolean
    field :date, Ecto.DateTime

    belongs_to :user, Janitor.User

    timestamps
  end

  def changeset(model, params \\ :empty) do 
    model
    |> cast(params, ~w(date), ~w(working user_id))    
  end 

end
