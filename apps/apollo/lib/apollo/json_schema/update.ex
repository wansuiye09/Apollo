defmodule Apollo.JSONSchema.Update do
  alias Ecto.Multi
  alias Apollo.Repo
  alias Apollo.JSONSchema
  alias Apollo.JSONSchema.CreateVersion
  alias Apollo.JSONSchema.Validator
  alias Apollo.JSONSchema.Helper
  alias Apollo.DB.JSONSchema, as: Schema

  def process(schema_id, schema, example) do
    (JSONSchema.get_schema(schema_id) || %Schema{})
    |> Schema.changeset(%{schema: schema, example: example})
    |> Helper.clean_schema()
    |> Helper.reject_empty_schema()
    |> Validator.validate()
    |> save
  end

  defp save(changeset) do
    Multi.new()
    |> Multi.update(:schema, changeset)
    |> CreateVersion.process()
    |> Repo.transaction()
  end
end
