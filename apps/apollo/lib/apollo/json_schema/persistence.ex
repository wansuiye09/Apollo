defmodule Apollo.JSONSchema.Persistence do
  alias Apollo.DB.JSONSchema, as: Schema

  def process(%Schema{} = record, func, schema, example)
      when is_function(func, 3) and is_map(schema) and is_map(example) do
    record
    |> build_and_validate(schema, example)
    |> schema_save(func)
  end

  defp build_and_validate(record, schema, example) do
    record
    |> Schema.changeset(%{schema: schema, example: example})
    |> Apollo.JSONSchema.Validation.process()
  end

  defp schema_save(changeset, func) do
    Ecto.Multi.new()
    |> func.(:schema, changeset)
    |> Apollo.JSONSchema.Versioning.process()
    |> Apollo.Repo.transaction()
  end
end
