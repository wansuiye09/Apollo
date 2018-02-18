use Mix.Config

# Configure your database
config :apollo, Apollo.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "apollo_test",
  pool: Ecto.Adapters.SQL.Sandbox
