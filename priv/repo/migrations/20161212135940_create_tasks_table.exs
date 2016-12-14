defmodule Janitor.Repo.Migrations.CreateTasks do
  use Ecto.Migration

    def change do
    create table(:tasks) do
      add :content, :text
      add :done, :boolean, default: false
      add :user_id, references(:users)
      add :day_id, references(:days)

      timestamps
    end
  end
end
