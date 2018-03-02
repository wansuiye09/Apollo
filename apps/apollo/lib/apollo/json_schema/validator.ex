defmodule Apollo.JSONSchema.Validator do
  alias ExJsonSchema.Schema.InvalidSchemaError
  import Ecto.Changeset

  def process(changeset) do
    try do
      schema = get_field(changeset, :schema) |> ExJsonSchema.Schema.resolve()

      case ExJsonSchema.Validator.validate(schema, get_field(changeset, :example)) do
        :ok ->
          {:ok, changeset, schema}

        {:error, errors} ->
          {:error,
           Enum.reduce(errors, changeset, fn {error, ref}, changeset ->
             add_error(changeset, :"example#{ref}", error)
           end)}
      end
    rescue
      error in InvalidSchemaError -> {:error, add_error(changeset, :schema, error)}
    end
  end
end
