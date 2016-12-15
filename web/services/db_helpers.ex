# require IEx
defmodule Janitor.DBHelpers do
  alias Janitor.Repo

  def find_or_create_by(structName, changeset, param \\ :id) do
    get_by_map = Map.take(changeset.changes, [param])
    entity = Repo.get_by(structName, get_by_map)
    case entity do
      nil -> Repo.insert(changeset)
      _ ->
        entity = Ecto.Changeset.change(entity, changeset.changes)
        {:ok, Repo.update!(entity)}
    end
  end

end
