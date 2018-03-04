defmodule Apollo.JSONSchemaTest do
  alias Apollo.JSONSchema
  alias Apollo.DB.JSONSchema, as: Schema
  alias Apollo.DB.JSONSchemaVersion, as: Version

  use ExUnit.Case
  doctest Apollo.JSONSchema

  setup_all do
    valid_schema = %{
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

    valid_example = %{
      "a" => :rand.uniform(1000),
      "billing-address" => %{
        "street-address" => "1st Street SE",
        "city" => "Washington",
        "state" => "DC"
      }
    }

    invalid_schema = %{"type" => "foobar"}

    invalid_example = %{
      "a" => "bob"
    }

    {:ok,
     valid_schema: valid_schema,
     invalid_schema: invalid_schema,
     valid_example: valid_example,
     invalid_example: invalid_example}
  end

  test "create valid schema and valid example", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Apollo.Repo)
    result = JSONSchema.create(state[:valid_schema], state[:valid_example])

    assert {:ok, %{schema: %Schema{}, schema_version: %Version{}}} = result
  end

  test "does not create empty schema and valid example", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Apollo.Repo)
    result = JSONSchema.create(%{}, state[:valid_example])

    assert %Ecto.Changeset{} = result
  end

  test "does not create invalid schema and valid example", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Apollo.Repo)
    result = JSONSchema.create(state[:invalid_schema], state[:valid_example])

    assert %Ecto.Changeset{} = result
  end

  test "does not create valid schema and invalid example", state do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Apollo.Repo)
    result = JSONSchema.create(state[:valid_schema], state[:invalid_example])

    assert %Ecto.Changeset{} = result
  end

  test "validate valid schema", state do
    result = JSONSchema.validate(state[:valid_schema])

    assert result |> elem(0) == :ok
  end

  test "validate invalid schema", state do
    schema = state[:invalid_schema]
    result = JSONSchema.validate(schema)

    assert result |> elem(0) == :error
    assert is_binary(result |> elem(1)) == true
  end

  test "validate valid example and valid schema", state do
    result = JSONSchema.validate(state[:valid_schema], state[:valid_example])

    assert result == :ok
  end

  test "validate invalid example and valid schema", state do
    result = JSONSchema.validate(state[:valid_schema], state[:invalid_example])

    assert result |> elem(0) == :error
    assert is_list(result |> elem(1)) == true
  end
end
