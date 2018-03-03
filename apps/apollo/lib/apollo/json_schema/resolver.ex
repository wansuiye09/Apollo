defmodule Apollo.JSONSchema.Resolver do
  import Ecto.Query, only: [from: 2]
  alias ExJsonSchema.Schema.InvalidSchemaError
  @remote_protocols ["http", "https"]

  def remote_resolve(url) when is_binary(url) do
    if Enum.member?(@remote_protocols, URI.parse(url).scheme) do
      HTTPoison.get!(url).body |> Poison.decode!()
    else
      default_raise(url)
    end
  end

  def local_resolve(url) when is_binary(url) do
    uri = URI.parse(url)

    table =
      case uri.scheme do
        "schema" -> "json_schemas"
        "schema-version" -> "json_schema_versions"
      end

    if table do
      query =
        from(
          schm in table,
          where: schm.id == type(^uri.host, :binary_id),
          select: schm.schema
        )

      Apollo.Repo.one(query) || raise InvalidSchemaError, message: "Reference not found - #{url}"
    else
      default_raise(url)
    end
  end

  defp default_raise(url)
       when is_binary(url),
       do: raise(InvalidSchemaError, message: "Reference unsupported - #{url}")
end
