defmodule ApolloWeb.Router do
  use ApolloWeb, :router

  pipeline :api do
    plug(:accepts, ["json-api"])
    plug(JaSerializer.ContentTypeNegotiation)
    plug(JaSerializer.Deserializer)
  end

  scope "/api/v1", ApolloWeb do
    pipe_through(:api)
    resources("/json_schemas", JSONSchemaController, except: [:new, :edit])
  end
end
