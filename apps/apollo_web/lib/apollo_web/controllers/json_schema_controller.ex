defmodule ApolloWeb.JSONSchemaController do
  use ApolloWeb, :controller

  alias ApolloWeb.API.V1
  alias Apollo.DB.JSONSchema
  alias JaSerializer.Params

  action_fallback(ApolloWeb.FallbackController)

  def index(conn, _params) do
    json_schemas = V1.list_json_schemas()
    render(conn, "index.json-api", data: json_schemas)
  end

  def create(conn, %{
        "data" => data = %{"type" => "json-schema", "attributes" => json_schema_params}
      }) do
    with {:ok, %JSONSchema{} = json_schema} <- V1.create_json_schema(json_schema_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", json_schema_path(conn, :show, json_schema))
      |> render("show.json-api", data: json_schema)
    end
  end

  def show(conn, %{"id" => id}) do
    json_schema = V1.get_json_schema!(id)
    render(conn, "show.json-api", data: json_schema)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "json-schema", "attributes" => json_schema_params}
      }) do
    json_schema = V1.get_json_schema!(id)

    with {:ok, %JSONSchema{} = json_schema} <-
           V1.update_json_schema(json_schema, json_schema_params) do
      render(conn, "show.json-api", data: json_schema)
    end
  end

  def delete(conn, %{"id" => id}) do
    json_schema = V1.get_json_schema!(id)

    with {:ok, %JSONSchema{}} <- V1.delete_json_schema(json_schema) do
      send_resp(conn, :no_content, "")
    end
  end
end
