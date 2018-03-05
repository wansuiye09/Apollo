defmodule ApolloWeb.V1.SchemaView do
  use ApolloWeb, :view
  use JaSerializer.PhoenixView
  alias ApolloWeb.V1.SchemaVersionView, as: VersionSerializer
  alias ApolloWeb.V1.SchemaVersionService, as: Versions

  attributes([:active, :meta_schema, :schema, :example, :inserted_at, :updated_at])

  has_many(
    :versions,
    links: [
      related: "/api/v1/schemas/:id/versions",
      self: "/api/v1/schemas/:id/relationships/versions"
    ],
    serializer: VersionSerializer,
    include: true
  )

  has_one(
    :current_version,
    links: [
      related: "/api/v1/schemas/:id/current-version",
      self: "/api/v1/schemas/:id/relationships/current-version"
    ],
    serializer: VersionSerializer,
    include: true
  )

  def versions(schema, _conn), do: Versions.list(schema.id)
  def current_version(schema, _conn), do: Versions.get_current!(schema.id)
end
