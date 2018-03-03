defmodule Apollo.JSONSchema do
  alias Apollo.JSONSchema.Create
  alias Apollo.JSONSchema.Validator

  def create(schema, example) when is_map(schema) and is_map(example) do
    Create.process(schema, example)
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

  def validate(schema) when is_map(schema), do: Validator.validate(schema)

  def validate(schema, example) when is_map(schema) and is_map(example),
    do: Validator.validate(schema, example)
end
