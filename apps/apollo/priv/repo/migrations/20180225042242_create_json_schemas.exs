defmodule Apollo.Repo.Migrations.CreateJsonSchemas do
  use Ecto.Migration

  def change do
    create table(:json_schemas, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:meta_schema, :string, null: false)
      add(:schema, :map, null: false)
      add(:example, :map, null: false)

      timestamps()
    end
  end
end
