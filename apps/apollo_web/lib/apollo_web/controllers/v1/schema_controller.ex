defmodule ApolloWeb.V1.SchemaController do
  use ApolloWeb, :controller

  alias ApolloWeb.V1.SchemaService, as: Schemas
  alias Apollo.DB.JSONSchema, as: Schema
  alias JaSerializer.Params

  action_fallback(ApolloWeb.FallbackController)

  def index(conn, _params) do
    schemas = Schemas.list()
    render(conn, "index.json-api", data: schemas)
  end

  def create(conn, %{"data" => data = %{"type" => "schema"}}) do
    with {:ok, %Schema{} = schema} <- Schemas.create(Params.to_attributes(data)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", schema_path(conn, :show, schema))
      |> render("show.json-api", data: schema)
    end
  end

  def parent_schema(conn, %{"schema_version_id" => version_id}) do
    version = ApolloWeb.V1.SchemaVersionService.get!(version_id)
    show(conn, %{"id" => version.json_schema_id})
  end

  def show(conn, %{"id" => id}) do
    schema = Schemas.get!(id)
    render(conn, "show.json-api", data: schema)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "schema"}}) do
    schema = Schemas.get!(id)

    with {:ok, %Schema{} = schema} <- Schemas.update(schema, Params.to_attributes(data)) do
      render(conn, "show.json-api", data: schema)
    end
  end

  def delete(conn, %{"id" => id}) do
    schema = Schemas.get!(id)

    with {:ok, %Schema{}} <- Schemas.delete(schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
