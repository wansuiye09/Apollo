use Mix.Config

config :apollo, ecto_repos: [Apollo.Repo]

import_config "#{Mix.env}.exs"
