use Mix.Config

# Configure your database
if System.get_env("CI") == "true" do
  config :apollo, Apollo.Repo,
    adapter: Ecto.Adapters.Postgres,
    hostname: System.get_env("POSTGRES_PORT_5432_TCP_ADDR"),
    username: "postgres",
    database: "apollo_test",
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :apollo, Apollo.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: "apollo_test",
    pool: Ecto.Adapters.SQL.Sandbox
end
