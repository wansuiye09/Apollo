defmodule ApolloWeb.V1.SchemaController do
  use ApolloWeb, :controller

  alias ApolloWeb.V1.SchemaService
  alias Apollo.DB.JSONSchema, as: Schema
  alias JaSerializer.Params

  action_fallback(ApolloWeb.FallbackController)

  def index(conn, _params) do
    schemas = SchemaService.list()
    render(conn, "index.json-api", data: schemas)
  end

  def create(conn, %{
        "data" => data = %{"type" => "schema", "attributes" => schema_params}
      }) do
    with {:ok, %Schema{} = schema} <- SchemaService.create(schema_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", schema_path(conn, :show, schema))
      |> render("show.json-api", data: schema)
    end
  end

  def show(conn, %{"id" => id}) do
    schema = SchemaService.get!(id)
    render(conn, "show.json-api", data: schema)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "schema", "attributes" => schema_params}
      }) do
    schema = SchemaService.get!(id)

    with {:ok, %Schema{} = schema} <- SchemaService.update(schema, schema_params) do
      render(conn, "show.json-api", data: schema)
    end
  end

  def delete(conn, %{"id" => id}) do
    schema = SchemaService.get!(id)

    with {:ok, %Schema{}} <- SchemaService.delete(schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
