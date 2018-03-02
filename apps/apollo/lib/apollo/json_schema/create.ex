defmodule Apollo.JSONSchema.Create do
  alias Apollo.Repo
  alias Apollo.DB.JSONSchema
  alias Apollo.JSONSchema.Validator
  alias Apollo.JSONSchema.Helper

  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field(:active, :boolean, default: true)
    field(:meta_schema, :string, default: Helper.default_schema_url())
    field(:schema, :map)
    field(:example, :map)
  end

  def process(schema, example) when is_map(schema) and is_map(example),
    do: changeset(%{schema: schema, example: example})

  defp changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:schema, :example])
    |> Helper.clean_schema()
    |> Helper.reject_empty_schema()
    |> validate_then_save
  end

  defp validate_then_save(changeset) do
    if changeset.valid? do
      case Validator.process(changeset) do
        {:ok, changeset, schema} -> save(changeset, schema)
        {:error, changeset, _schema} -> changeset
      end
    else
      changeset
    end
  end

  defp save(changeset, _schema) do
    attrs = Map.from_struct(changeset |> apply_changes)

    case Repo.insert(JSONSchema.changeset(%JSONSchema{}, attrs)) do
      {_status, schema} -> schema
    end
  end
end
