defmodule ApolloWeb.V1.SchemaView do
  use ApolloWeb, :view
  use JaSerializer.PhoenixView

  attributes([:active, :example, :meta_schema, :schema, :inserted_at, :updated_at])
end
