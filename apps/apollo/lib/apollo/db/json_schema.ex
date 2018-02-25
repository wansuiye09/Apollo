defmodule Apollo.DB.JSONSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Apollo.DB.JSONSchema
  alias Apollo.DB.JSONSchemaVersion

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "json_schemas" do
    has_many(:json_schema_versions, JSONSchemaVersion)

    field(:meta_schema, :string)
    field(:example, :map)
    field(:schema, :map)

    timestamps()
  end

  @doc false
  def changeset(%JSONSchema{} = json_schema, attrs) do
    json_schema
    |> cast(attrs, [:meta_schema, :schema, :example])
    |> validate_required([:meta_schema, :schema, :example])
  end
end
