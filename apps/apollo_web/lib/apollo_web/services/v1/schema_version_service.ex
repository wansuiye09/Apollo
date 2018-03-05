defmodule ApolloWeb.V1.SchemaVersionService do
  @moduledoc """
  The API.V1.SchemaVersionService context.
  """

  @doc """
  Returns the list of schema versions.

  ## Examples

      iex> list()
      [%Version{}, ...]

  """
  def list(schema_id), do: Apollo.JSONSchema.get_versions(schema_id)

  @doc """
  Gets a single schema version.

  Raises `Ecto.NoResultsError` if the schema version does not exist.

  ## Examples

      iex> get!(123)
      %Version{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Apollo.JSONSchema.get_version(id)

  @doc """
  Gets a single schema version, based on the parent schema ID.

  Raises `Ecto.NoResultsError` if the schema does not exist.

  ## Examples

      iex> get_current!(123)
      %Version{}

      iex> get_current!(456)
      ** (Ecto.NoResultsError)

  """
  def get_current!(schema_id), do: Apollo.JSONSchema.get_current_version(schema_id)
end
