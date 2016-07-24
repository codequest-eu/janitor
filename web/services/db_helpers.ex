defmodule Janitor.DBHelpers do 
  alias Janitor.Repo

  def find_or_create_by(structName, changeset, param \\ :id) do 
    get_by_map = Map.take(changeset.params, [param])
    entity = Repo.get_by(structName, get_by_map)
    case entity do 
      nil -> Repo.insert(changeset)
      _ -> {:ok, entity }
    end
  end 
 
end 
