use Mix.Config

# Configure your database
config :apollo, Apollo.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "apollo_dev",
  pool_size: 10
