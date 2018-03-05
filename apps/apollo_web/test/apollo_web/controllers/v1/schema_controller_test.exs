defmodule ApolloWeb.V1.SchemaControllerTest do
  use ApolloWeb.ConnCase
  import Apollo.DataCase

  alias ApolloWeb.V1.SchemaService
  alias Apollo.DB.JSONSchema, as: Schema

  @create_attrs %{example: valid_json_schema_example(), schema: valid_json_schema()}
  @update_attrs %{example: valid_json_schema_example(), schema: valid_json_schema()}
  @invalid_attrs %{example: invalid_json_schema_example(), schema: invalid_json_schema()}

  def fixture(:schema) do
    {:ok, schema} = SchemaService.create(@create_attrs)
    schema
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

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, schema_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "creates schema and renders schema when data is valid", %{conn: conn} do
    conn =
      post(conn, schema_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "schema",
          "attributes" => @create_attrs,
          "relationships" => relationships()
        }
      })

    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, schema_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "schema"
    assert data["attributes"]["example"] == @create_attrs.example
    assert data["attributes"]["schema"] == @create_attrs.schema
  end

  test "does not create schema and renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, schema_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "schema",
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen schema and renders schema when data is valid", %{conn: conn} do
    %Schema{id: id} = schema = fixture(:schema)

    conn =
      put(conn, schema_path(conn, :update, schema), %{
        "meta" => %{},
        "data" => %{
          "type" => "schema",
          "id" => "#{schema.id}",
          "attributes" => @update_attrs,
          "relationships" => relationships()
        }
      })

    conn = get(conn, schema_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{id}"
    assert data["type"] == "schema"
    assert data["attributes"]["example"] == @update_attrs.example
    assert data["attributes"]["schema"] == @update_attrs.schema
  end

  test "does not update chosen schema and renders errors when data is invalid", %{conn: conn} do
    schema = fixture(:schema)

    conn =
      put(conn, schema_path(conn, :update, schema), %{
        "meta" => %{},
        "data" => %{
          "type" => "schema",
          "id" => "#{schema.id}",
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen schema", %{conn: conn} do
    schema = fixture(:schema)
    conn = delete(conn, schema_path(conn, :delete, schema))
    assert response(conn, 204)

    assert_error_sent(404, fn ->
      get(conn, schema_path(conn, :show, schema))
    end)
  end
end
