defmodule Maychat.Contexts.Users do
  @moduledoc """
  Context API for Users Schema. Acts as a thin layer of abstraction for the functions
  that mutate or access the users table.
  """
  alias Maychat.Mutations

  ## Mutations
  defdelegate register(params), to: Mutations.User, as: :create
end
