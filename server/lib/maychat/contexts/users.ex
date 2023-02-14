defmodule Maychat.Contexts.Users do
  @moduledoc """
  Context API for Users Schema. Acts as a thin layer of abstraction for the functions
  that mutate or access the users table.
  """
  alias Maychat.Queries
  alias Maychat.Mutations

  # NOTE: Maybe remove specs?
  # => For now removing specs

  ## Queries
  defdelegate get_user_by_username_email(username_email), to: Queries.User
  defdelegate get_user_by_id(id), to: Queries.User
  defdelegate get_encrypted_pwd!(user), to: Queries.User
  defdelegate get_token_version_by_id!(id), to: Queries.User
  defdelegate list_users(), to: Queries.User

  ## Mutations
  defdelegate create_user(params), to: Mutations.User
  defdelegate update_user(user, params), to: Mutations.User
  defdelegate delete_user(user), to: Mutations.User
  defdelegate increment_token_version(user), to: Mutations.User
end
