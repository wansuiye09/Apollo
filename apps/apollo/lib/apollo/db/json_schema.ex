defmodule Apollo.DB.JSONSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Apollo.DB.JSONSchema
  alias Apollo.DB.JSONSchemaVersion

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "json_schemas" do
    has_many(:versions, JSONSchemaVersion)

    field(:active, :boolean)
    field(:meta_schema, :string)
    field(:example, :map)
    field(:schema, :map)

    timestamps()
  end

  @doc false
  def changeset(%JSONSchema{} = json_schema, attrs) do
    json_schema
    |> cast(attrs, [:active, :meta_schema, :schema, :example])
    |> validate_required([:active, :meta_schema, :schema, :example])
  end
end
