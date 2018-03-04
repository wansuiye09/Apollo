defmodule Apollo.JSONSchema do
  alias Apollo.Repo
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version
  alias Apollo.JSONSchema.Create
  alias Apollo.JSONSchema.Update
  alias Apollo.JSONSchema.Validator

  import Ecto.Query, only: [from: 2]

  def validate(schema)
      when is_map(schema),
      do: Validator.validate(schema)

  def validate(schema, example)
      when is_map(schema) and is_map(example),
      do: Validator.validate(schema, example)

  def create(schema, example)
      when is_map(schema) and is_map(example),
      do: Create.process(schema, example)

  def update(id, schema, example)
      when is_map(schema) and is_map(example),
      do: Update.process(id, schema, example)

  def get_schema(schema_id), do: Repo.one(get_schema_query(schema_id))

  def get_schema_query(schema_id),
    do: from(sch in Schema, where: sch.id == type(^schema_id, :binary_id))

  def get_version(version_id), do: Repo.one(get_version_query(version_id))

  def get_version_query(version_id),
    do: from(ver in Version, where: ver.id == type(^version_id, :binary_id))

  def get_current_version(schema_id), do: Repo.one(get_current_version_query(schema_id))

  def get_current_version_query(schema_id) do
    from(
      ver in Version,
      where: ver.json_schema_id == type(^schema_id, :binary_id),
      order_by: [desc: ver.version],
      limit: 1
    )
  end
end
