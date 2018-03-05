defmodule Apollo.JSONSchemaTest do
  alias Apollo.Repo
  alias Apollo.JSONSchema
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version

  use Apollo.DataCase
  doctest Apollo.JSONSchema

  setup_all do
    {:ok,
     valid_schema: valid_json_schema(),
     invalid_schema: invalid_json_schema(),
     valid_example: valid_json_schema_example(),
     invalid_example: invalid_json_schema_example()}
  end

  test "retrieves a schema with versions", state do
    {:ok, %{schema: schema, schema_version: _version}} =
      JSONSchema.create(state[:valid_schema], state[:valid_example])

    assert JSONSchema.get_schema(schema.id) == schema
  end

  test "raises an error when retrieving a non-exisistant schema ID" do
    assert_raise Ecto.NoResultsError, fn ->
      JSONSchema.get_schema(Ecto.UUID.generate())
    end
  end

  test "retrieves a schema version with the parent_schema", state do
    {:ok, %{schema_version: version}} =
      JSONSchema.create(state[:valid_schema], state[:valid_example])

    assert JSONSchema.get_version(version.id) == version
  end

  test "raises an error when retrieving a non-exisistant schema version ID" do
    assert_raise Ecto.NoResultsError, fn ->
      JSONSchema.get_version(Ecto.UUID.generate())
    end
  end

  test "retrieves a current schema version with the parent_schema", state do
    {:ok, %{schema: schema, schema_version: version}} =
      JSONSchema.create(state[:valid_schema], state[:valid_example])

    assert JSONSchema.get_current_version(schema.id) == version
  end

  test "raises an error when retrieving a non-exisistant schema ID for a current version" do
    assert_raise Ecto.NoResultsError, fn ->
      JSONSchema.get_current_version(Ecto.UUID.generate())
    end
  end

  test "create valid schema and valid example", state do
    result = JSONSchema.create(state[:valid_schema], state[:valid_example])

    assert {:ok, %{schema: %Schema{}, schema_version: %Version{}}} = result
  end

  test "does not create empty schema and valid example", state do
    result = JSONSchema.create(%{}, state[:valid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "does not create invalid schema and valid example", state do
    result = JSONSchema.create(state[:invalid_schema], state[:valid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "does not create valid schema and invalid example", state do
    result = JSONSchema.create(state[:valid_schema], state[:invalid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "update valid schema and valid example", state do
    {:ok, %{schema: schema}} = JSONSchema.create(state[:valid_schema], state[:valid_example])

    result = JSONSchema.update(schema.id, state[:valid_schema], state[:valid_example])

    version_count =
      Repo.one(
        from(ver in Version, where: ver.json_schema_id == ^schema.id, select: count(ver.id))
      )

    assert {:ok, %{schema: %Schema{}, schema_version: %Version{}}} = result
    assert version_count == 2
  end

  test "raises an error when updating a non-exisistant ID", state do
    assert_raise Ecto.NoResultsError, fn ->
      JSONSchema.update(Ecto.UUID.generate(), state[:valid_schema], state[:valid_example])
    end
  end

  test "does not update empty schema and valid example", state do
    {:ok, %{schema: schema}} = JSONSchema.create(state[:valid_schema], state[:valid_example])

    result = JSONSchema.update(schema.id, %{}, state[:valid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "does not update invalid schema and valid example", state do
    {:ok, %{schema: schema}} = JSONSchema.create(state[:valid_schema], state[:valid_example])

    result = JSONSchema.update(schema.id, state[:invalid_schema], state[:valid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "does not update valid schema and invalid example", state do
    {:ok, %{schema: schema}} = JSONSchema.create(state[:valid_schema], state[:valid_example])

    result = JSONSchema.update(schema.id, state[:valid_schema], state[:invalid_example])

    assert %Ecto.Changeset{} = result |> elem(2)
  end

  test "validate valid schema", state do
    result = JSONSchema.validate(state[:valid_schema])

    assert result |> elem(0) == :ok
  end

  test "validate invalid schema", state do
    schema = state[:invalid_schema]
    result = JSONSchema.validate(schema)

    assert result |> elem(0) == :error
    assert is_binary(result |> elem(1)) == true
  end

  test "validate valid example and valid schema", state do
    result = JSONSchema.validate(state[:valid_schema], state[:valid_example])

    assert result == :ok
  end

  test "validate invalid example and valid schema", state do
    result = JSONSchema.validate(state[:valid_schema], state[:invalid_example])

    assert result |> elem(0) == :error
    assert is_list(result |> elem(1)) == true
  end
end
