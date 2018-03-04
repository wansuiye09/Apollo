defmodule Apollo.JSONSchema.Persistence do
  alias Apollo.DB.JSONSchema, as: Schema

  def process(%Schema{} = record, multi, schema, example)
      when is_function(multi, 3) and is_map(schema) and is_map(example) do
    record
    |> cast(schema, example)
    |> validate()
    |> save(multi)
  end

  defp cast(record, schema, example),
    do: record |> Schema.changeset(%{schema: schema, example: example})

  defp validate(changeset), do: Apollo.JSONSchema.Validation.process(changeset)

  defp save(changeset, multi) do
    Ecto.Multi.new()
    |> multi.(:schema, changeset)
    |> Apollo.JSONSchema.Versioning.process()
    |> Apollo.Repo.transaction()
  end
end
