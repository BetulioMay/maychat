defmodule MaychatWebTest.Utils.ErrorsTest do
  use ExUnit.Case, async: true

  alias Maychat.Schemas.User
  alias MaychatWeb.Utils.Errors

  @some_params %{
    username: nil,
    email: nil,
    password: nil
  }
  @err_string_pttr ~r/(.*)(: )(.*)/

  setup do
    changeset = User.changeset(%User{}, @some_params)

    %{changeset: changeset}
  end

  test "normalize/1 for Ecto.Changeset", %{changeset: changeset = %Ecto.Changeset{}} do
    normalized =
      changeset
      |> Errors.NormalizeError.normalize()

    # Must be a list
    assert is_list(normalized) == true

    # Must be a list of strings
    assert Enum.all?(normalized, &is_binary(&1)) == true

    # Strings must have format: "%change: %message"
    assert Enum.all?(normalized, fn err when is_binary(err) ->
             Regex.match?(@err_string_pttr, err)
           end) == true
  end
end
