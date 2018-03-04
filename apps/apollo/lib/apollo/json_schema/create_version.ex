defmodule Apollo.JSONSchema.CreateVersion do
  alias Apollo.Repo
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version

  import Ecto.Query, only: [from: 2]

  def process(multi), do: Ecto.Multi.run(multi, :schema_version, &create_version/1)

  defp create_version(%{schema: %Schema{} = schema}) do
    version_attrs =
      schema
      |> Map.from_struct()
      |> Map.put(:json_schema_id, schema.id)
      |> Map.put(:version, next_version_number(schema))

    %Version{}
    |> Version.changeset(version_attrs)
    |> Repo.insert()
  end

  defp next_version_number(%Schema{id: id}) do
    1 +
      Repo.one(
        from(
          schm in Schema,
          join: ver in assoc(schm, :versions),
          where: schm.id == ^id,
          select: count(ver.id)
        )
      )
  end
end
