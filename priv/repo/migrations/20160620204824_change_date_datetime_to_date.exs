defmodule Janitor.Repo.Migrations.ChangeDateDatetimeToDate do
  use Ecto.Migration

  def change do
    alter table(:days) do 
      modify :date, :date
    end 
  end
end
