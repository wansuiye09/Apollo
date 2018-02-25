defmodule Apollo.Repo.Migrations.CreateJsonSchemaVersions do
  use Ecto.Migration

  def change do
    create table(:json_schema_versions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :json_schema_id,
        references(:json_schemas, on_delete: :delete_all, type: :binary_id),
        null: false
      )

      add(:version, :integer, null: false)
      add(:meta_schema, :string, null: false)
      add(:schema, :map, null: false)
      add(:example, :map, null: false)

      timestamps()
    end

    create(index(:json_schema_versions, [:json_schema_id]))
  end
end
