defmodule Janitor.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do 
      add :first_name, :string
      add :last_name, :string
      add :google_id, :string
      add :email, :string

      timestamps
    end 
  end
end
