use Mix.Config

# Configure your database
if System.get_env("CI") == "true" do
  config :apollo, Apollo.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :apollo, Apollo.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: "apollo_test",
    pool: Ecto.Adapters.SQL.Sandbox
end
