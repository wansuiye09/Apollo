defmodule Apollo.JSONSchema.Create do
  alias Apollo.Repo
  alias Ecto.Multi
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.JSONSchema.CreateVersion
  alias Apollo.JSONSchema.Validator
  alias Apollo.JSONSchema.Helper

  def process(schema, example) do
    %Schema{meta_schema: Helper.default_schema_url(), active: true}
    |> Schema.changeset(%{schema: schema, example: example})
    |> Helper.clean_schema()
    |> Helper.reject_empty_schema()
    |> Validator.validate()
    |> save
  end

  defp save(changeset) do
    Multi.new()
    |> Multi.insert(:schema, changeset)
    |> CreateVersion.process()
    |> Repo.transaction()
  end
end
