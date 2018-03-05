defmodule ApolloWeb.V1.SchemaVersionController do
  use ApolloWeb, :controller

  alias ApolloWeb.V1.SchemaVersionService, as: Versions

  action_fallback(ApolloWeb.FallbackController)

  def index(conn, %{"schema_id" => schema_id}) do
    versions = Versions.list(schema_id)
    render(conn, "index.json-api", data: versions)
  end

  def show(conn, %{"id" => id}) do
    version = Versions.get!(id)
    render(conn, "show.json-api", data: version)
  end

  def current_version(conn, %{"schema_id" => schema_id}) do
    version = Versions.get_current!(schema_id)
    render(conn, "show.json-api", data: version)
  end
end
