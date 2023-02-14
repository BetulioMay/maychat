defmodule MaychatWebTest.Utils.ErrorsTest do
  use ExUnit.Case, async: true

  alias Maychat.Schemas.User
  alias MaychatWeb.Utils.Errors.NormalizeError

  @some_params %{
    username: nil,
    email: nil,
    password: nil
  }

  setup do
    changeset = User.changeset(%User{}, @some_params)
    atom_err = :invalid
    str_err = "invalid"

    context = :some_context

    %{changeset: changeset, atom_err: atom_err, str_err: str_err, context: context}
  end

  describe "protocol NormalizeError" do
    test "normalize/2 for Ecto.Changeset", %{changeset: changeset} do
      normalized = NormalizeError.normalize(changeset)

      # Check normalization
      assert is_map(normalized) == true
      assert Enum.all?(normalized, fn {k, v} -> is_atom(k) and is_list(v) end)
    end

    test "normalize/2 for Atom/String with context", %{
      atom_err: atom_err,
      str_err: str_err,
      context: some_context
    } do
      normalized_for_atom = NormalizeError.normalize(atom_err, some_context)
      normalized_for_str = NormalizeError.normalize(str_err, some_context)

      assert is_map(normalized_for_atom)
      assert is_map(normalized_for_str)

      assert Enum.all?(normalized_for_atom, fn {k, v} ->
               (is_atom(k) or is_binary(k)) and is_list(v)
             end)

      assert Enum.all?(normalized_for_str, fn {k, v} ->
               (is_atom(k) or is_binary(k)) and is_list(v)
             end)
    end

    test "normalize/2 for Atom/String without context", %{
      atom_err: atom_err,
      str_err: str_err
    } do
      assert_raise ArgumentError, fn -> NormalizeError.normalize(atom_err, nil) end
      assert_raise ArgumentError, fn -> NormalizeError.normalize(str_err, nil) end
    end
  end
end
