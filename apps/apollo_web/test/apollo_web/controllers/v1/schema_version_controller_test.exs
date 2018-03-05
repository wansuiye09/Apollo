defmodule ApolloWeb.V1.SchemaVersionControllerTest do
  use ApolloWeb.ConnCase
  import Apollo.DataCase

  alias ApolloWeb.V1.SchemaService, as: Schemas
  alias ApolloWeb.V1.SchemaVersionService, as: Versions
  alias Apollo.DB.JSONSchema, as: Schema

  @schema_attrs %{example: valid_json_schema_example(), schema: valid_json_schema()}

  def fixture(:schema) do
    {:ok, schema} = Schemas.create(@schema_attrs)
    schema
  end

  def fixture(:version) do
    Versions.get_current!(fixture(:schema).id)
  end

  defp relationships do
    %{}
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "shows a single schema version", %{conn: conn} do
    version = fixture(:version)
    conn = get(conn, schema_version_path(conn, :show, version))

    render =
      ApolloWeb.V1.SchemaVersionView
      |> JaSerializer.format(version, conn)
      |> Poison.encode!()
      |> Poison.decode!()

    assert json_response(conn, 200) == render
  end

  test "index shows all the versions belonging to a parent schema", %{conn: conn} do
    schema = fixture(:schema)
    version = Versions.get_current!(schema.id)
    conn = get(conn, schema_versions_path(conn, :index, schema))

    render =
      ApolloWeb.V1.SchemaVersionView
      |> JaSerializer.format(version, conn)
      |> Poison.encode!()
      |> Poison.decode!()

    assert Enum.fetch(json_response(conn, 200)["data"], 0) |> elem(1) == render["data"]
  end
end
