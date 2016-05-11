defmodule Janitor.CustomMatchers do 
  def is_not(value) do
    quote do
      assert !value
    end
  end
end 