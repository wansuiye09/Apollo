defmodule ApolloWeb.V1.SchemaServiceTest do
  use Apollo.DataCase

  alias ApolloWeb.V1.SchemaService

  describe "schemas" do
    alias Apollo.DB.JSONSchema, as: Schema

    @valid_attrs %{example: valid_json_schema_example(), schema: valid_json_schema()}
    @update_attrs @valid_attrs
    @invalid_attrs %{example: invalid_json_schema_example(), schema: invalid_json_schema()}

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SchemaService.create()

      schema
    end

    test "list/0 returns all schemas" do
      schema = schema_fixture()
      assert SchemaService.list() == [schema]
    end

    test "get!/1 returns the schema with given id" do
      schema = schema_fixture()
      assert SchemaService.get!(schema.id) == schema
    end

    test "create/1 with valid data creates a schema" do
      assert {:ok, %Schema{} = schema} = SchemaService.create(@valid_attrs)
      assert schema.example == @valid_attrs.example
      assert schema.schema == @valid_attrs.schema
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SchemaService.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the schema" do
      schema = schema_fixture()
      assert {:ok, schema} = SchemaService.update(schema, @update_attrs)
      assert %Schema{} = schema
      assert schema.example == @update_attrs.example
      assert schema.schema == @update_attrs.schema
    end

    test "update/2 with invalid data returns error changeset" do
      schema = schema_fixture()
      assert {:error, %Ecto.Changeset{}} = SchemaService.update(schema, @invalid_attrs)
      assert schema == SchemaService.get!(schema.id)
    end

    test "delete/1 deletes the schema" do
      schema = schema_fixture()
      assert {:ok, %Schema{}} = SchemaService.delete(schema)
      assert_raise Ecto.NoResultsError, fn -> SchemaService.get!(schema.id) end
    end

    test "change/1 returns a schema changeset" do
      schema = schema_fixture()
      assert %Ecto.Changeset{} = SchemaService.change(schema)
    end
  end
end
