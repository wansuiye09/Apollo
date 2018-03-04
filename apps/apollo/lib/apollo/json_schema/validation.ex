defmodule Apollo.JSONSchema.Validation do
  @default_schema_url "http://json-schema.org/draft-04/schema#"
  def default_schema_url, do: @default_schema_url

  alias ExJsonSchema.Schema.InvalidSchemaError
  import Ecto.Changeset

  def process(%Ecto.Changeset{} = changeset), do: validate_and_resolve(changeset) |> elem(1)

  def validate_and_resolve(%Ecto.Changeset{} = changeset) do
    changeset
    |> reject_empty_schema()
    |> clean_schema()
    |> resolve_schema()
    |> validate_example()
  end

  def validate(%Ecto.Changeset{} = changeset), do: process(changeset)

  def validate(schema) when is_map(schema), do: resolve_schema(schema)

  def validate(%ExJsonSchema.Schema.Root{} = schema, example) when is_map(example),
    do: ExJsonSchema.Validator.validate(schema, example)

  def validate(schema, example) when is_map(schema) and is_map(example) do
    case resolve_schema(schema) do
      {:ok, resolved_schema} -> validate(resolved_schema, example)
      {:error, error} -> {:error, error}
    end
  end

  defp reject_empty_schema(changeset) do
    if stripped_schema(changeset) == %{} do
      add_error(changeset, :schema, "Can't be empty.")
    else
      changeset
    end
  end

  defp stripped_schema(changeset),
    do: get_field(changeset, :schema) |> Map.drop(["$schema", "$id"])

  defp cleaned_schema(changeset),
    do: stripped_schema(changeset) |> Map.put("$schema", @default_schema_url)

  defp clean_schema(changeset) do
    if changeset.valid? do
      put_change(
        changeset,
        :schema,
        cleaned_schema(changeset)
      )
    else
      changeset
    end
  end

  defp resolve_schema(%Ecto.Changeset{} = changeset) do
    case get_field(changeset, :schema) |> resolve_schema do
      {:ok, schema} -> {:ok, changeset, schema}
      {:error, error} -> {:error, add_error(changeset, :schema, error), nil}
    end
  end

  defp resolve_schema(schema) when is_map(schema) do
    try do
      {:ok, schema |> ExJsonSchema.Schema.resolve()}
    rescue
      error in InvalidSchemaError -> {:error, error.message}
    end
  end

  defp validate_example({status, changeset, resolved_schema}) do
    case status do
      :ok ->
        case validate(resolved_schema, get_field(changeset, :example)) do
          :ok ->
            {:ok, changeset, resolved_schema}

          {:error, errors} ->
            {:error, Enum.reduce(errors, changeset, &add_error_to_example/2), nil}
        end

      :error ->
        {:error, changeset, nil}
    end
  end

  defp add_error_to_example({error, ref}, changeset),
    do: add_error(changeset, "example#{ref}", error)
end
