defmodule Janitor.DBHelpers do 
  alias Janitor.Repo

  def find_or_create_by(structName, changeset, param \\ :id) do 
    get_by_map = Map.take(changeset.params, [param])
    entity = Repo.get_by(structName, get_by_map)
    case entity do 
      nil -> create(changeset)
      _ -> entity    
    end
  end 

  defp create(changeset) do 
    {:ok, entity} = Repo.insert(changeset)
    entity
  end 

end 