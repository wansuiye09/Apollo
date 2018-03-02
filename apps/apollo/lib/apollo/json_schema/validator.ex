defmodule Apollo.JSONSchema.Validator do
  alias ExJsonSchema.Schema.InvalidSchemaError
  import Ecto.Changeset

  def process(changeset) do
    changeset
    |> resolve_schema
    |> validate_example
  end

  defp resolve_schema(changeset) do
    try do
      {:ok, changeset, get_field(changeset, :schema) |> ExJsonSchema.Schema.resolve()}
    rescue
      error in InvalidSchemaError -> {:error, add_error(changeset, :schema, error), nil}
    end
  end

  defp validate_example({resolved, changeset, schema}) do
    case resolved do
      :ok ->
        case ExJsonSchema.Validator.validate(schema, get_field(changeset, :example)) do
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
    do: add_error(changeset, :example, "#{ref} - #{error}")
end
