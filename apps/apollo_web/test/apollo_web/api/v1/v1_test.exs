defmodule ApolloWeb.V1Test do
  use Apollo.DataCase

  alias ApolloWeb.API.V1

  describe "json_schemas" do
    alias Apollo.DB.JSONSchema

    @valid_attrs %{active: true, example: %{}, meta_schema: "some meta_schema", schema: %{}}
    @update_attrs %{
      active: false,
      example: %{},
      meta_schema: "some updated meta_schema",
      schema: %{}
    }
    @invalid_attrs %{active: nil, example: nil, meta_schema: nil, schema: nil}

    def json_schema_fixture(attrs \\ %{}) do
      {:ok, json_schema} =
        attrs
        |> Enum.into(@valid_attrs)
        |> V1.create_json_schema()

      json_schema
    end

    test "list_json_schemas/0 returns all json_schemas" do
      json_schema = json_schema_fixture()
      assert V1.list_json_schemas() == [json_schema]
    end

    test "get_json_schema!/1 returns the json_schema with given id" do
      json_schema = json_schema_fixture()
      assert V1.get_json_schema!(json_schema.id) == json_schema
    end

    test "create_json_schema/1 with valid data creates a json_schema" do
      assert {:ok, %JSONSchema{} = json_schema} = V1.create_json_schema(@valid_attrs)
      assert json_schema.active == true
      assert json_schema.example == %{}
      assert json_schema.meta_schema == "some meta_schema"
      assert json_schema.schema == %{}
    end

    test "create_json_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = V1.create_json_schema(@invalid_attrs)
    end

    test "update_json_schema/2 with valid data updates the json_schema" do
      json_schema = json_schema_fixture()
      assert {:ok, json_schema} = V1.update_json_schema(json_schema, @update_attrs)
      assert %JSONSchema{} = json_schema
      assert json_schema.active == false
      assert json_schema.example == %{}
      assert json_schema.meta_schema == "some updated meta_schema"
      assert json_schema.schema == %{}
    end

    test "update_json_schema/2 with invalid data returns error changeset" do
      json_schema = json_schema_fixture()
      assert {:error, %Ecto.Changeset{}} = V1.update_json_schema(json_schema, @invalid_attrs)
      assert json_schema == V1.get_json_schema!(json_schema.id)
    end

    test "delete_json_schema/1 deletes the json_schema" do
      json_schema = json_schema_fixture()
      assert {:ok, %JSONSchema{}} = V1.delete_json_schema(json_schema)
      assert_raise Ecto.NoResultsError, fn -> V1.get_json_schema!(json_schema.id) end
    end

    test "change_json_schema/1 returns a json_schema changeset" do
      json_schema = json_schema_fixture()
      assert %Ecto.Changeset{} = V1.change_json_schema(json_schema)
    end
  end
end
