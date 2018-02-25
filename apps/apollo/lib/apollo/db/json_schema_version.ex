defmodule Apollo.DB.JSONSchemaVersion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Apollo.DB.JSONSchema
  alias Apollo.DB.JSONSchemaVersion

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "json_schema_versions" do
    belongs_to(:json_schema, JSONSchema)

    field(:version, :integer)
    field(:meta_schema, :string)
    field(:schema, :map)
    field(:example, :map)

    timestamps()
  end

  @doc false
  def changeset(%JSONSchemaVersion{} = json_schema_version, attrs) do
    json_schema_version
    |> cast(attrs, [:version, :meta_schema, :schema, :example])
    |> validate_required([:version, :meta_schema, :schema, :example])
  end
end
