defmodule Apollo.JSONSchema.Helper do
  @default_schema_url "http://json-schema.org/draft-04/schema#"
  def default_schema_url, do: @default_schema_url

  import Ecto.Changeset

  def clean_schema(changeset) do
    changeset
    |> put_change(:schema, cleaned_schema(changeset) |> Map.put("$schema", @default_schema_url))
  end

  def reject_empty_schema(changeset) do
    if cleaned_schema(changeset) == %{} do
      add_error(changeset, :schema, "Can't be empty.")
    else
      changeset
    end
  end

  defp cleaned_schema(changeset) do
    get_field(changeset, :schema)
    |> Map.drop(["$schema", :"$schema"])
  end
end
