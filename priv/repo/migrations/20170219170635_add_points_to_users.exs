defmodule Janitor.Repo.Migrations.AddPointsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :points, :integer, default: 0
    end 
  end
end
