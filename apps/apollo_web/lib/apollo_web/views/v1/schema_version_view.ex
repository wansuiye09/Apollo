defmodule ApolloWeb.V1.SchemaVersionView do
  use ApolloWeb, :view
  use JaSerializer.PhoenixView
  alias ApolloWeb.V1.SchemaView, as: SchemaSerializer
  alias ApolloWeb.V1.SchemaService, as: Schemas

  attributes([:meta_schema, :schema, :example, :inserted_at, :updated_at])

  has_one(
    :parent_schema,
    links: [
      related: "/api/v1/schema-versions/:id/parent-schema",
      self: "/api/v1/schemas/:id/relationships/parent-schema"
    ],
    serializer: SchemaSerializer,
    include: true
  )

  def parent_schema(version, _conn), do: Schemas.get!(version.json_schema_id)
end
