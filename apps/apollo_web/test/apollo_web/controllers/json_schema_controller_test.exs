defmodule ApolloWeb.JSONSchemaControllerTest do
  use ApolloWeb.ConnCase

  alias ApolloWeb.API.V1
  alias Apollo.DB.JSONSchema

  @create_attrs %{active: true, example: %{}, meta_schema: "some meta_schema", schema: %{}}
  @update_attrs %{
    active: false,
    example: %{},
    meta_schema: "some updated meta_schema",
    schema: %{}
  }
  @invalid_attrs %{active: nil, example: nil, meta_schema: nil, schema: nil}

  def fixture(:json_schema) do
    {:ok, json_schema} = V1.create_json_schema(@create_attrs)
    json_schema
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
    conn = get(conn, json_schema_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "creates json_schema and renders json_schema when data is valid", %{conn: conn} do
    conn =
      post(conn, json_schema_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "json-schema",
          "attributes" => @create_attrs,
          "relationships" => relationships()
        }
      })

    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, json_schema_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "json-schema"
    assert data["attributes"]["active"] == @create_attrs.active
    assert data["attributes"]["example"] == @create_attrs.example
    assert data["attributes"]["meta-schema"] == @create_attrs.meta_schema
    assert data["attributes"]["schema"] == @create_attrs.schema
  end

  test "does not create json_schema and renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, json_schema_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "json-schema",
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen json_schema and renders json_schema when data is valid", %{conn: conn} do
    %JSONSchema{id: id} = json_schema = fixture(:json_schema)

    conn =
      put(conn, json_schema_path(conn, :update, json_schema), %{
        "meta" => %{},
        "data" => %{
          "type" => "json-schema",
          "id" => "#{json_schema.id}",
          "attributes" => @update_attrs,
          "relationships" => relationships()
        }
      })

    conn = get(conn, json_schema_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{id}"
    assert data["type"] == "json-schema"
    assert data["attributes"]["active"] == @update_attrs.active
    assert data["attributes"]["example"] == @update_attrs.example
    assert data["attributes"]["meta-schema"] == @update_attrs.meta_schema
    assert data["attributes"]["schema"] == @update_attrs.schema
  end

  test "does not update chosen json_schema and renders errors when data is invalid", %{conn: conn} do
    json_schema = fixture(:json_schema)

    conn =
      put(conn, json_schema_path(conn, :update, json_schema), %{
        "meta" => %{},
        "data" => %{
          "type" => "json-schema",
          "id" => "#{json_schema.id}",
          "attributes" => @invalid_attrs,
          "relationships" => relationships()
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen json_schema", %{conn: conn} do
    json_schema = fixture(:json_schema)
    conn = delete(conn, json_schema_path(conn, :delete, json_schema))
    assert response(conn, 204)

    assert_error_sent(404, fn ->
      get(conn, json_schema_path(conn, :show, json_schema))
    end)
  end
end
