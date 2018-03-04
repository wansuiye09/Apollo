defmodule Apollo.JSONSchema.Persistence do
  @default_schema_url "http://json-schema.org/draft-04/schema#"
  def default_schema_url, do: @default_schema_url

  import Ecto.Changeset

  def save(record, func, schema, example) do
    record
    |> build_and_validate(schema, example)
    |> schema_save(func)
  end

  defp build_and_validate(record, schema, example) do
    record
    |> Apollo.DB.JSONSchema.changeset(%{schema: schema, example: example})
    |> clean_schema()
    |> reject_empty_schema()
    |> Apollo.JSONSchema.Validation.validate()
  end

  defp clean_schema(changeset) do
    put_change(
      changeset,
      :schema,
      cleaned_schema(changeset) |> Map.put("$schema", @default_schema_url)
    )
  end

  defp reject_empty_schema(changeset) do
    case cleaned_schema(changeset) == %{} do
      true -> add_error(changeset, :schema, "Can't be empty.")
      false -> changeset
    end
  end

  defp cleaned_schema(changeset) do
    get_field(changeset, :schema)
    |> Map.drop(["$schema", :"$schema"])
    |> Map.drop(["$id", :"$id"])
  end

  defp schema_save(changeset, func) do
    Ecto.Multi.new()
    |> func.(:schema, changeset)
    |> Apollo.JSONSchema.Versioning.process()
    |> Apollo.Repo.transaction()
  end
end
