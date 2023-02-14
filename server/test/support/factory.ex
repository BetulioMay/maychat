defmodule Maychat.Support.Factory do
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

  def create(:user) do
    some_user_params = %{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.free_email(),
      password: Faker.Lorem.word(),
      avatar_url: Faker.Avatar.image_url() <> ".jpg"
    }

    confirmation = Map.get(some_user_params, :password)

    # IO.inspect(@some_user_params, label: "some user params")
    # IO.inspect(confirmation, label: "confirmation password")

    user =
      %User{}
      |> User.changeset(Map.put(some_user_params, :password_confirmation, confirmation))
      |> Repo.insert!(returning: true)

    user
  end
end
