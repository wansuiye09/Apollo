defmodule Apollo.Application do
  @moduledoc """
  The Apollo Application Service.

  The apollo system business domain lives in this application.

  Exposes API to clients such as the `ApolloWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        supervisor(Apollo.Repo, [])
      ],
      strategy: :one_for_one,
      name: Apollo.Supervisor
    )
  end
end
