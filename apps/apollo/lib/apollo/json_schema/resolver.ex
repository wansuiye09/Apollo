defmodule Apollo.JSONSchema.Resolver do
  @remote_protocols ["http", "https"]
  alias ExJsonSchema.Schema.InvalidSchemaError

  import Ecto.Query, only: [from: 2]

  def remote_resolve(url) when is_binary(url) do
    if Enum.member?(@remote_protocols, URI.parse(url).scheme) do
      HTTPoison.get!(url).body |> Poison.decode!()
    else
      default_raise(url)
    end
  end

  def local_resolve(url) when is_binary(url) do
    URI.parse(url)
    |> query(url)
    |> Apollo.Repo.one() || not_found(url)
  end

  defp query(uri, url) do
    from(
      schm in (get_table(uri) || default_raise(url)),
      where: schm.id == type(^uri.host, :binary_id),
      select: schm.schema
    )
  end

  defp get_table(uri) do
    case uri.scheme do
      "schema" -> "json_schemas"
      "schema-version" -> "json_schema_versions"
    end
  end

  defp not_found(url), do: raise(InvalidSchemaError, message: "Reference not found - #{url}")

  defp default_raise(url),
    do: raise(InvalidSchemaError, message: "Reference unsupported - #{url}")
end
