Code.require_file("#{__DIR__}/phoenix_helper.exs")

ESpec.configure fn(config) ->

  config.before fn ->
    Ecto.Adapters.SQL.restart_test_transaction(Janitor.Repo, [])
    {:ok, _} = Application.ensure_all_started(:ex_machina)
  end

  config.finally fn(_shared) ->
    :ok
  end
end
