{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Janitor.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Janitor.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Janitor.Repo)

