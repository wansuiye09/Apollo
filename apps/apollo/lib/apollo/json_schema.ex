defmodule Apollo.JSONSchema do
  alias Apollo.Repo
  alias Apollo.JSONSchema.Resolution
  alias Apollo.JSONSchema.Formatting
  alias Apollo.JSONSchema.Validation
  alias Apollo.JSONSchema.Persistence
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version
  import Ecto.Query, only: [from: 2]

  def validate(schema)
      when is_map(schema),
      do: Resolution.process(schema)

  def validate(schema, example)
      when is_map(schema) and is_map(example),
      do: Validation.process(schema, example)

  def create(attrs \\ %{}) do
    %Schema{}
    |> Persistence.process(&Ecto.Multi.insert/3, attrs)
  end

  def create(schema, example) when is_map(schema) and is_map(example) do
    %Schema{schema: schema, example: example}
    |> Persistence.process(&Ecto.Multi.insert/3)
  end

  def update(%Schema{} = record, attrs \\ %{}),
    do: record |> Persistence.process(&Ecto.Multi.update/3, attrs)

  def update(id, schema, example) when is_map(schema) and is_map(example) do
    get_schema(id)
    |> Persistence.process(&Ecto.Multi.update/3, %{schema: schema, example: example})
  end

  def get_schema(schema_id), do: get_schema_query(schema_id) |> Repo.one!()

  def get_schema_query(schema_id),
    do: from(sch in Schema, where: sch.id == type(^schema_id, :binary_id))

  def get_version(version_id), do: get_version_query(version_id) |> Repo.one!()

  def get_version_query(version_id),
    do: from(ver in Version, where: ver.id == type(^version_id, :binary_id))

  def get_current_version(schema_id), do: get_current_version_query(schema_id) |> Repo.one!()

  def get_current_version_query(schema_id) do
    from(
      ver in Version,
      where: ver.json_schema_id == type(^schema_id, :binary_id),
      order_by: [desc: ver.version],
      limit: 1
    )
  end
end
