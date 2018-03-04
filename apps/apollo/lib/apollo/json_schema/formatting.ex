defmodule Apollo.JSONSchema.Formatting do
  import Ecto.Changeset

  @default_schema_url "http://json-schema.org/draft-04/schema#"
  def default_schema_url, do: @default_schema_url

  def process(%Ecto.Changeset{} = changeset),
    do: put_change(changeset, :schema, cleaned_schema(changeset))

  def stripped_schema(%Ecto.Changeset{} = changeset),
    do: get_field(changeset, :schema) |> Map.drop(["$schema", "$id"])

  defp cleaned_schema(changeset),
    do: stripped_schema(changeset) |> Map.put("$schema", @default_schema_url)
end
