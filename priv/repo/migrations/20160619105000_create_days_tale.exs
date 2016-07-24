defmodule Janitor.Repo.Migrations.CreateDaysTable do
  use Ecto.Migration

  def change do
    create table(:days) do 
      add :working, :boolean, default: true
      add :date, :date
      add :user_id, references(:users)
      timestamps
    end 

    create unique_index(:days, [:date])
  end
end
