defmodule ApolloWeb.V1.SchemaService do
  @moduledoc """
  The API.V1.SchemaService context.
  """

  import Ecto.Query, warn: false
  alias Apollo.Repo

  alias Apollo.DB.JSONSchema, as: Schema

  @doc """
  Returns the list of schemas.

  ## Examples

      iex> list()
      [%Schema{}, ...]

  """
  def list do
    Repo.all(Schema)
  end

  @doc """
  Gets a single schema.

  Raises `Ecto.NoResultsError` if the schema does not exist.

  ## Examples

      iex> get!(123)
      %Schema{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Schema, id)

  @doc """
  Creates a schema.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Schema{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a schema.

  ## Examples

      iex> update(schema, %{field: new_value})
      {:ok, %Schema{}}

      iex> update(schema, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Schema{} = schema, attrs) do
    schema
    |> Schema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Schema.

  ## Examples

      iex> delete(schema)
      {:ok, %Schema{}}

      iex> delete(schema)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Schema{} = schema) do
    Repo.delete(schema)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schema changes.

  ## Examples

      iex> change(schema)
      %Ecto.Changeset{source: %Schema{}}

  """
  def change(%Schema{} = schema) do
    Schema.changeset(schema, %{})
  end
end
