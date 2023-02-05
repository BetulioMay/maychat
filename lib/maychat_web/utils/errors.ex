defmodule MaychatWeb.Utils.Errors do
  @moduledoc """
  Utils for dealing with errors.
  """

  defprotocol NormalizeError do
    @doc """
    Normalize the given data structure `errors`
    """
    @spec normalize(term()) :: [String.t()]
    def normalize(errors)
  end

  defimpl NormalizeError, for: Ecto.Changeset do
    def normalize(changeset = %Ecto.Changeset{}) do
      changeset.errors
      |> Enum.map(fn {k, {msg, _}} ->
        to_string(k) <> ": " <> msg
      end)
    end
  end
end
