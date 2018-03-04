use Mix.Config

config :apollo, ecto_repos: [Apollo.Repo]

config :ex_json_schema, :remote_schema_resolver, {Apollo.JSONSchema.Resolution, :process}

import_config "#{Mix.env()}.exs"
