defmodule MaychatWeb.Utils.Errors do
  @moduledoc """
  Utils for dealing with errors.
  """
  import Ecto.Changeset, only: [traverse_errors: 2]

  defprotocol NormalizeError do
    def normalize(err, context \\ nil)
  end

  defimpl NormalizeError, for: Ecto.Changeset do
    def normalize(changeset, _context) do
      changeset
      |> traverse_errors(fn {msg, _opts} ->
        msg
      end)
    end
  end

  defimpl NormalizeError, for: BitString do
    def normalize(err_str, context) when not is_nil(context) do
      %{
        to_string(context) => List.wrap(err_str)
      }
    end

    def normalize(_, _), do: raise(ArgumentError, "Error context is missing.")
  end

  defimpl NormalizeError, for: Atom do
    def normalize(err_atom, context) when not is_nil(context) do
      %{
        to_string(context) => List.wrap(err_atom)
      }
    end

    def normalize(_, _), do: raise(ArgumentError, "Error context is missing.")
  end

  ## WARNING: protocol is going to be tested, this is a fallback solution
  # @spec normalize_string_err(atom(), atom() | String.t()) :: map()
  # def normalize_atom_err(err, context) when is_atom(err) do
  #   %{
  #     context => [to_string(err)]
  #   }
  # end

  # @spec normalize_string_err(String.t(), atom() | String.t()) :: map()
  # def normalize_string_err(err, context) when is_binary(err) do
  #   %{
  #     context => [err]
  #   }
  # end

  # def normalize_changeset_err(changeset) do
  #   changeset
  #   |> traverse_errors(fn {msg, _opts} ->
  #     msg
  #   end)
  # end
end
