defmodule ApolloWeb.Router do
  use ApolloWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ApolloWeb do
    pipe_through(:api)
  end
end
