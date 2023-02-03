defmodule Maychat.Mutations.User do
  @moduledoc """
  Mutation functions for users table.

  All called functions receive a `params` argument that is a map with
  fields required to insert or update a user.

  Example:
    - `%{username: "Bob", email: "bob@bob.com", password: "secret", avatar_url: nil} = params`
  """
  alias Maychat.Schemas.User
  alias Maychat.Repo

  @spec create(%{atom() => String.t()}) :: {:ok, User.t()} | {:error, %Ecto.Changeset{}}
  def create(params) when is_map(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
