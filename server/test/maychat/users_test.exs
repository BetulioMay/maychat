defmodule Maychat.UsersTest do
  @moduledoc """
  Test user's context units
  """
  use ExUnit.Case, async: true
  use Maychat.RepoCase

  alias Maychat.Contexts.Users
  alias Maychat.Schemas.User
  alias Maychat.Support.Factory

  setup do
    {:ok, user: Factory.create(:user)}
  end

  describe "get_user_by_username_email/1" do
    test "with valid credentials, should return user schema", %{user: user} do
      %User{id: curr_id, username: username, email: email} = user
      # By email
      %User{id: id} = Users.get_user_by_username_email(email)
      assert id == curr_id

      # By username
      %User{id: id} = Users.get_user_by_username_email(username)
      assert id == curr_id
    end

    test "with nil username/email, should return nil" do
      assert nil == Users.get_user_by_username_email(nil)
    end

    test "with no existing user with username/email should return nil" do
      # there's no way a username is in base64
      no_existing_username = Faker.String.base64()

      assert Users.get_user_by_username_email(no_existing_username) == nil

      # Same with email
      no_existing_email = Faker.String.base64()

      assert Users.get_user_by_username_email(no_existing_email) == nil
    end
  end

  test "get_user_by_id/1", %{user: user} do
    %User{id: id} = user

    # should return user struct
    fetched = Users.get_user_by_id(id)
    assert fetched.id == user.id
    assert fetched.username == user.username
    assert fetched.email == user.email

    # with no existing id, return nil
    assert Users.get_user_by_id(-1) == nil
  end

  test "get_hashed_pwd!/1", %{user: user} do
    # Password should be a hash
    %User{password_hash: encoded} = user

    hash = Users.get_hashed_pwd!(user)

    # Encoded is always two times the hash since is base16 encoding (hex)
    assert String.length(hash) * 2 == String.length(encoded)

    # no valid encoded password will raise an error
    invalid_user =
      struct(User, %{
        password_hash: "GJKLRJTKLG"
      })

    assert_raise(ArgumentError, fn -> Users.get_hashed_pwd!(invalid_user) end)
  end

  describe "get_token_version_by_id!/1" do
    test "it should return 0", %{user: user} do
      assert Users.get_token_version_by_id!(user.id) == 0
    end

    test "it should raise if there's no user with id" do
      assert_raise(Ecto.NoResultsError, fn -> Users.get_token_version_by_id!(-1) end)
    end
  end
end
