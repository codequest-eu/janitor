defmodule Janitor.Repo.Migrations.AddDefaultToTasks do
  use Ecto.Migration

  def change do
     alter table(:tasks) do
      add :default, :boolean, default: false
    end
  end
end
