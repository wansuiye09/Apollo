# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :apollo_web,
  namespace: ApolloWeb,
  ecto_repos: [Apollo.Repo]

# Configures the endpoint
config :apollo_web, ApolloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eNKNtgRPrmXhHrYtjLDdAHXajyRdNCrdujnosYJf5bjhd5P88IXwHBacpJVQphg6",
  render_errors: [view: ApolloWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApolloWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :apollo_web, :generators, context_app: :apollo, binary_id: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
