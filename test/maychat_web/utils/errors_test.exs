defmodule MaychatWebTest.Utils.ErrorsTest do
  use ExUnit.Case, async: true

  alias Maychat.Schemas.User
  import MaychatWeb.Utils.Errors

  @some_params %{
    username: nil,
    email: nil,
    password: nil
  }

  setup do
    changeset = User.changeset(%User{}, @some_params)

    %{changeset: changeset}
  end

  test "normalize_changeset_err/1", %{changeset: changeset = %Ecto.Changeset{}} do
    normalized =
      changeset
      |> normalize_changeset_err()

    IO.inspect(normalized)
    # Check normalization
    assert is_map(normalized) == true
    assert Enum.all?(normalized, fn {k, v} -> is_atom(k) and is_list(v) end)
  end

  test "normalize_atom_err/1" do
    normalized = :invalid |> normalize_atom_err()

    assert is_map(normalized)
    assert normalized = %{error: ["invalid"]}
  end

  test "normalize_string_err/1" do
    normalized = "invalid" |> normalize_string_err()

    assert is_map(normalized)
    assert normalized = %{error: ["invalid"]}
  end
end
