defmodule Apollo.JSONSchema.Formatting do
  import Ecto.Changeset

  @default_schema_url "http://json-schema.org/draft-04/schema#"
  def default_schema_url, do: @default_schema_url

  def fill_field(changeset, field \\ :schema)
  def fill_field(%Ecto.Changeset{valid?: false} = changeset, _field), do: changeset

  def fill_field(%Ecto.Changeset{} = changeset, field),
    do: changeset |> replace_field(&fill/1, field)

  def fill(map) when is_map(map), do: map |> Map.put("$schema", @default_schema_url)

  def strip_field(changeset, field \\ :schema)
  def strip_field(%Ecto.Changeset{valid?: false} = changeset, _field), do: changeset

  def strip_field(%Ecto.Changeset{} = changeset, field),
    do: changeset |> replace_field(&strip/1, field)

  def strip(map) when is_map(map), do: map |> Map.drop(["$schema", "$id"])

  defp replace_field(changeset, func, field),
    do: put_change(changeset, field, get_field(changeset, field) |> func.())
end
