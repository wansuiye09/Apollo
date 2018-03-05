defmodule ApolloWeb.API.V1 do
  @moduledoc """
  The API.V1 context.
  """

  import Ecto.Query, warn: false
  alias Apollo.Repo

  alias Apollo.DB.JSONSchema

  @doc """
  Returns the list of json_schemas.

  ## Examples

      iex> list_json_schemas()
      [%JSONSchema{}, ...]

  """
  def list_json_schemas do
    Repo.all(JSONSchema)
  end

  @doc """
  Gets a single json_schema.

  Raises `Ecto.NoResultsError` if the Json schema does not exist.

  ## Examples

      iex> get_json_schema!(123)
      %JSONSchema{}

      iex> get_json_schema!(456)
      ** (Ecto.NoResultsError)

  """
  def get_json_schema!(id), do: Repo.get!(JSONSchema, id)

  @doc """
  Creates a json_schema.

  ## Examples

      iex> create_json_schema(%{field: value})
      {:ok, %JSONSchema{}}

      iex> create_json_schema(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_json_schema(attrs \\ %{}) do
    %JSONSchema{}
    |> JSONSchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a json_schema.

  ## Examples

      iex> update_json_schema(json_schema, %{field: new_value})
      {:ok, %JSONSchema{}}

      iex> update_json_schema(json_schema, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_json_schema(%JSONSchema{} = json_schema, attrs) do
    json_schema
    |> JSONSchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a JSONSchema.

  ## Examples

      iex> delete_json_schema(json_schema)
      {:ok, %JSONSchema{}}

      iex> delete_json_schema(json_schema)
      {:error, %Ecto.Changeset{}}

  """
  def delete_json_schema(%JSONSchema{} = json_schema) do
    Repo.delete(json_schema)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking json_schema changes.

  ## Examples

      iex> change_json_schema(json_schema)
      %Ecto.Changeset{source: %JSONSchema{}}

  """
  def change_json_schema(%JSONSchema{} = json_schema) do
    JSONSchema.changeset(json_schema, %{})
  end
end
