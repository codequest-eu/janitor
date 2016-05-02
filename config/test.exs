use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :janitor, Janitor.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :janitor, Janitor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "janitor_test",
  host:  System.get_env("JANITOR_DB_1_PORT_5432_TCP_ADDR"), 
  port: System.get_env("JANITOR_DB_1_PORT_5432_TCP_PORT"),
  pool_size: 10
  pool: Ecto.Adapters.SQL.Sandbox
