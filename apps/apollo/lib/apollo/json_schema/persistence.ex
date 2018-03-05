defmodule Apollo.JSONSchema.Persistence do
  alias Apollo.DB.JSONSchema, as: Schema

  def process(%Schema{} = record, multi, attrs \\ %{}) when is_function(multi, 3) do
    record
    |> Schema.changeset(attrs)
    |> Apollo.JSONSchema.Validation.process()
    |> save(multi)
  end

  defp save(changeset, multi) do
    Ecto.Multi.new()
    |> multi.(:schema, changeset)
    |> Apollo.JSONSchema.Versioning.process()
    |> Apollo.Repo.transaction()
  end
end
