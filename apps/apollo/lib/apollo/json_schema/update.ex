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
      not_found()
    else
      record
      |> Schema.changeset(%{schema: schema, example: example})
      |> Helper.clean_schema()
      |> Helper.reject_empty_schema()
      |> Validator.validate()
      |> save
    end
  end

  defp save(changeset) do
    Multi.new()
    |> Multi.update(:schema, changeset)
    |> CreateVersion.process()
    |> Repo.transaction()
  end

  defp not_found do
    {:error, :schema,
     %Schema{}
     |> Schema.changeset(%{})
     |> Ecto.Changeset.add_error(:id, "not found")}
  end
end
