defmodule Apollo.JSONSchema.Resolution do
  alias ExJsonSchema.Schema.InvalidSchemaError
  import Ecto.Query, only: [from: 2]

  def process(url) when is_binary(url), do: local_resolve(url)

  def process(schema) when is_map(schema) do
    try do
      {:ok, schema |> ExJsonSchema.Schema.resolve()}
    rescue
      error in InvalidSchemaError -> {:error, error.message}
    end
  end

  defp local_resolve(url) do
    URI.parse(url)
    |> query()
    |> Apollo.Repo.one() || raise(InvalidSchemaError, message: "Reference not found - #{url}")
  end

  defp query(uri) do
    from(
      schm in get_table(uri),
      where: schm.id == type(^uri.host, :binary_id),
      select: schm.schema
    )
  end

  defp get_table(uri) do
    case uri.scheme do
      "schema" -> "json_schemas"
      "schema-version" -> "json_schema_versions"
    end || raise(InvalidSchemaError, message: "Reference unsupported - #{uri}")
  end
end
