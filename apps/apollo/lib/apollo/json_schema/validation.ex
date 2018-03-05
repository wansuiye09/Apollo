defmodule Apollo.JSONSchema.Validation do
  alias Apollo.JSONSchema.Resolution
  alias Apollo.JSONSchema.Formatting
  import Ecto.Changeset

  def process(%Ecto.Changeset{} = changeset), do: resolved_validation(changeset) |> elem(1)

  def process(%ExJsonSchema.Schema.Root{} = schema, example) when is_map(example),
    do: ExJsonSchema.Validator.validate(schema, example)

  def process(schema, example) when is_map(schema) and is_map(example) do
    case Resolution.process(schema) do
      {:ok, resolved_schema} -> process(resolved_schema, example)
      {:error, _error_message} = error -> error
    end
  end

  def resolved_validation(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_inclusion(:meta_schema, [Formatting.default_schema_url()])
    |> Formatting.strip()
    |> empty_check()
    |> Formatting.fill()
    |> resolve_schema()
    |> validate_example()
  end

  defp empty_check(changeset) do
    if get_field(changeset, :schema) == %{} do
      add_error(changeset, :schema, "Can't be empty.")
    else
      changeset
    end
  end

  defp resolve_schema(%Ecto.Changeset{valid?: false} = changeset), do: {:error, changeset, nil}

  defp resolve_schema(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :schema) |> Resolution.process() do
      {:ok, resolved_schema} -> {:ok, changeset, resolved_schema}
      {:error, error} -> {:error, add_error(changeset, :schema, error), nil}
    end
  end

  defp validate_example({:error, _changeset, _resolved_schema} = message), do: message

  defp validate_example({:ok, changeset, resolved_schema}) do
    case process(resolved_schema, get_field(changeset, :example)) do
      :ok -> {:ok, changeset, resolved_schema}
      {:error, errors} -> {:error, Enum.reduce(errors, changeset, &add_error_to_example/2), nil}
    end
  end

  defp add_error_to_example({error, ref}, changeset),
    do: add_error(changeset, "example#{ref}", error)
end
