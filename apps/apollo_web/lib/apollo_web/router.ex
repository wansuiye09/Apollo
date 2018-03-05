defmodule ApolloWeb.Router do
  use ApolloWeb, :router

  pipeline :json_api do
    plug(:accepts, ["json-api"])
    plug(JaSerializer.ContentTypeNegotiation)
  end

  scope "/api/v1", ApolloWeb.V1 do
    pipe_through(:json_api)
    resources("/schemas", SchemaController, except: [:new, :edit])
  end
end
