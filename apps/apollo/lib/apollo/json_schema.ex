defmodule Apollo.JSONSchema do
  alias Apollo.Repo
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version
  alias Apollo.JSONSchema.Create
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
      do: nil

  def get_schema(schema_id),
    do: Repo.one(from(sch in Schema, where: sch.id == type(^schema_id, :binary_id)))

  def get_version(version_id),
    do: Repo.one(from(ver in Version, where: ver.id == type(^version_id, :binary_id)))

  def get_current_version(schema_id) do
    Repo.one(
      from(
        ver in Version,
        where: ver.json_schema_id == type(^schema_id, :binary_id),
        order_by: [desc: ver.version],
        limit: 1
      )
    )
  end
end
