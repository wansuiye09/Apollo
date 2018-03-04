defmodule Apollo.JSONSchema.Update do
  alias Ecto.Multi
  alias Apollo.Repo
  alias Apollo.JSONSchema.CreateVersion
  alias Apollo.JSONSchema.Validator
  alias Apollo.JSONSchema.Helper
  alias Apollo.DB.JSONSchema, as: Schema

  def process(schema_id, schema, example) do
    record = Apollo.JSONSchema.get_schema(schema_id)

    if record == nil do
      raise Ecto.NoResultsError, queryable: Apollo.JSONSchema.get_schema_query(schema_id)
    end

    {_status, changeset, _resolved_schema} =
      record
      |> Schema.changeset(%{schema: schema, example: example})
      |> Helper.clean_schema()
      |> Helper.reject_empty_schema()
      |> Validator.validate()

    if changeset.valid? do
      Multi.new()
      |> Multi.update(:schema, changeset)
      |> CreateVersion.process()
      |> Repo.transaction()
    else
      changeset
    end
  end
end
