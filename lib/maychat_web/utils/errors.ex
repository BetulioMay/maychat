defmodule MaychatWeb.Utils.Errors do
  @moduledoc """
  Utils for dealing with errors.
  """
  import Ecto.Changeset, only: [traverse_errors: 2]

  def normalize_atom_err(err) when is_atom(err) do
    %{
      error: [to_string(err)]
    }
  end

  def normalize_string_err(err) when is_binary(err) do
    %{
      error: [err]
    }
  end

  def normalize_changeset_err(changeset) do
    changeset
    |> traverse_errors(fn {msg, _opts} ->
      msg
    end)
  end
end
