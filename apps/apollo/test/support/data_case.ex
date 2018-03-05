defmodule Apollo.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Apollo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Apollo.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Apollo.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Apollo.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def valid_json_schema do
    %{
      "definitions" => %{
        "address" => %{
          "type" => "object",
          "properties" => %{
            "street-address" => %{"type" => "string"},
            "city" => %{"type" => "string"},
            "state" => %{"type" => "string"}
          },
          "required" => ["street-address", "city", "state"]
        }
      },
      "type" => "object",
      "properties" => %{
        "billing-address" => %{"$ref" => "#/definitions/address"},
        "shipping-address" => %{"$ref" => "#/definitions/address"},
        "a" => %{"type" => "integer"}
      },
      "required" => ["billing-address"]
    }
  end

  def valid_json_schema_example do
    %{
      "a" => :rand.uniform(1000),
      "billing-address" => %{
        "street-address" => "1st Street SE",
        "city" => "Washington",
        "state" => "DC"
      }
    }
  end

  def invalid_json_schema, do: %{"type" => "foobar"}
  def invalid_json_schema_example, do: %{"a" => "bob"}
end
