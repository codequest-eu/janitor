defmodule Janitor.Factory do
  use ExMachina.Ecto, repo: Janitor.Repo

  def factory(:google_plus_user) do 
    %{body: %{"emails" => [%{"value" => "test@test.pl"}], 
                "id" => "test_id", "displayName" => "Test test"}}

  end 
end 