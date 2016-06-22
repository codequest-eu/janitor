defmodule Janitor.UserFactory do
  use ExMachina.Ecto, repo: Janitor.Repo

  def factory(:user) do
    %Janitor.User{
      first_name: "Mark",
      last_name: "test",
      google_id: "test1234",
      email: sequence(:email, &"test#{&1}@test.com")
    }
  end

  def factory(:google_plus_user) do
    %{body: %{"emails" => [%{"value" => "test@test.pl"}],
    "id" => "test_id", "displayName" => "Test test"}}
  end
end
