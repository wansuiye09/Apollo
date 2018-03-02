defmodule Apollo.JSONSchema do
  alias __MODULE__
  alias Apollo.JSONSchema.Create

  @enforce_keys [:schema, :example]
  defstruct(
    id: nil,
    meta_schema: nil,
    schema: nil,
    example: nil,
    versions: nil,
    errors: nil,
    inserted_at: nil,
    updated_at: nil
  )

  def create(schema, example) when is_map(schema) and is_map(example) do
    struct(__MODULE__, Create.process(schema, example) |> Map.from_struct())
  end

  def get_schema(schema_id) when is_binary(schema_id) do
  end

  def get_schema_version(schema_version_id) when is_binary(schema_version_id) do
  end

  def get_current_version_for(schema_id) when is_binary(schema_id) do
  end

  def update(id, schema, example)
      when is_binary(id) and is_map(schema) and is_map(example) do
  end

  def validate_schema(schema) when is_map(schema) do
  end

  def validate_against_schema(schema, example) when is_map(schema) and is_map(example) do
  end
end
