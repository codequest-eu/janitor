defmodule Janitor.ViewHelpers do 
  def pick_fields(model, fields) do 
    model |> Map.from_struct |> Map.take(fields)
  end 
end 
