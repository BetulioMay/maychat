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

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def update_user(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete_user(%User{} = user), do: Repo.delete(user)
end
