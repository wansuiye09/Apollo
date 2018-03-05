defmodule ApolloWeb.Router do
  use ApolloWeb, :router

  pipeline :api do
    plug(:accepts, ["json-api"])
    plug(JaSerializer.ContentTypeNegotiation)
  end

  scope "/api/v1", ApolloWeb.V1 do
    pipe_through(:api)
    resources("/schemas", SchemaController, except: [:new, :edit])
  end
end
