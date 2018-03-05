defmodule ApolloWeb.Router do
  use ApolloWeb, :router

  pipeline :json_api do
    plug(:accepts, ["json-api"])
    plug(JaSerializer.ContentTypeNegotiation)
  end

  scope "/v1", ApolloWeb.V1 do
    pipe_through(:json_api)

    resources "/schema-versions", SchemaVersionController, only: [:show] do
      scope "/relationships", as: :relationships do
        get("/parent-schema", SchemaController, :parent_schema, as: :parent_schema)
      end

      get("/parent-schema", SchemaController, :parent_schema, as: :parent_schema)
    end

    resources "/schemas", SchemaController, except: [:new, :edit] do
      scope "/relationships", as: :relationships do
        resources("/versions", SchemaVersionController, only: [:index, :show], as: :versions)
        get("/current-version", SchemaVersionController, :current_version, as: :current_version)
      end

      resources("/versions", SchemaVersionController, only: [:index, :show], as: :versions)
      get("/current-version", SchemaVersionController, :current_version, as: :current_version)
    end
  end
end
