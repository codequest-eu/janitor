defmodule Janitor.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:google_id])
    create unique_index(:users, [:email])
  end
end
