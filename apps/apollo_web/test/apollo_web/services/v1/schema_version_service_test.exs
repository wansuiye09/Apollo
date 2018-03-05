defmodule ApolloWeb.V1.SchemaVersionServiceTest do
  use Apollo.DataCase

  alias ApolloWeb.V1.SchemaVersionService, as: Versions
  alias ApolloWeb.V1.SchemaService, as: Schemas

  describe "schema versions" do
    @valid_attrs %{example: valid_json_schema_example(), schema: valid_json_schema()}

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schemas.create()

      schema
    end

    def version_fixture do
      Versions.get_current!(schema_fixture().id)
    end

    test "list/1 returns all schemas" do
      schema = schema_fixture()
      version = Versions.get_current!(schema.id)
      assert Versions.list(schema.id) == [version]
    end

    test "get!/1 returns the schema version with given id" do
      version = version_fixture()
      assert Versions.get!(version.id) == version
    end

    test "get_current!/1 returns the current schema version for the given schema id" do
      schema = schema_fixture()
      old_version = Versions.get_current!(schema.id)
      schema |> Schemas.update(@valid_attrs)

      refute Versions.get_current!(schema.id) == old_version
    end
  end
end
