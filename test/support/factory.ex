defmodule MaychatTest.Support.Factory do
  @moduledoc """
  Factory support for testing.

  Defines de create/2 function, that accepts the following arguments:

  - Argument 1: Maychat struct intended to be create and to be inserted to the database, for now it supports the structs:
    - User
    - Group

  - Argument 2: Map of data that defines the struct
  """

  alias Maychat.Repo
  alias Maychat.Schemas.User
  alias Maychat.Schemas.Group

  def create(struct, dataset \\ [])

  def create(User, dataset) do
  end

  def create(Group, dataset) do
  end
end
