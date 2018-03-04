defmodule Apollo.JSONSchema.Validator do
  alias ExJsonSchema.Schema.InvalidSchemaError
  import Ecto.Changeset

  def validate(%Ecto.Changeset{} = changeset) do
    {_status, validated_changeset, _resolved_schema} =
      changeset
      |> resolve_in_changeset
      |> validate_example

    validated_changeset
  end

  def validate(schema)
      when is_map(schema),
      do: resolve_schema(schema)

  def validate_with_resolve(%Ecto.Changeset{} = changeset) do
    changeset
    |> resolve_in_changeset
    |> validate_example
  end

  def validate(%ExJsonSchema.Schema.Root{} = schema, example)
      when is_map(example),
      do: ExJsonSchema.Validator.validate(schema, example)

  def validate(schema, example) when is_map(schema) and is_map(example) do
    case resolve_schema(schema) do
      {:ok, resolved_schema} -> validate(resolved_schema, example)
      {:error, error} -> {:error, error}
    end
  end

  defp resolve_in_changeset(changeset) do
    case get_field(changeset, :schema) |> resolve_schema do
      {:ok, schema} -> {:ok, changeset, schema}
      {:error, error} -> {:error, add_error(changeset, :schema, error), nil}
    end
  end

  defp resolve_schema(schema) do
    try do
      {:ok, schema |> ExJsonSchema.Schema.resolve()}
    rescue
      error in InvalidSchemaError -> {:error, error.message}
    end
  end

  defp validate_example({resolved, changeset, schema}) do
    case resolved do
      :ok ->
        case validate(schema, get_field(changeset, :example)) do
          :ok ->
            {:ok, changeset, schema}

          {:error, errors} ->
            {:error, Enum.reduce(errors, changeset, &add_error_to_example/2), nil}
        end

      :error ->
        {:error, changeset, nil}
    end
  end

  defp add_error_to_example({error, ref}, changeset),
    do: add_error(changeset, "example#{ref}", "#{error}")
end
