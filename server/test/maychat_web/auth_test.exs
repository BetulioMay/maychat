defmodule MaychatWeb.AuthTest do
  use ExUnit.Case, async: true
  use Maychat.RepoCase

  alias Maychat.Schemas.User
  alias Maychat.Support.Factory
  alias MaychatWeb.Auth

  defp create_user(_) do
    {user, params} = Factory.create_and_params(:user)

    {:ok, user: user, params: params}
  end

  describe "a user is authenticated" do
    setup :create_user

    test "by username and password", %{user: user, params: params} do
      # {:ok, user} or {:error, reason}
      result =
        params
        |> Map.take([:username, :password])
        |> Auth.authenticate_user()

      assert {:ok, authenticated} = result
      assert user.id == authenticated.id
    end

    test "by email and password", %{user: user, params: params} do
      result =
        params
        |> Map.take([:email, :password])
        |> Auth.authenticate_user()

      assert {:ok, authenticated} = result
      assert user.id == authenticated.id
    end

    test "with invalid email/username, should fail", %{user: user, params: params} do
      ## Empty username/email is invalid
      result =
        params
        |> Map.take([:password])
        |> Map.put(:username, "")
        |> Map.put(:email, "")
        |> Auth.authenticate_user()

      assert {:error, :invalid_credentials} = result

      ## non-existing username/email is invalid
      invalid_username = Faker.String.base64()
      invalid_email = Faker.String.base64()

      should_fail_username =
        params
        |> Map.take([:password])
        # random username that doesn't exists
        |> Map.put(:username, invalid_username)
        |> Auth.authenticate_user()

      should_fail_email =
        params
        |> Map.take([:password])
        # random username that doesn't exists
        |> Map.put(:username, invalid_username)
        |> Auth.authenticate_user()

      refute invalid_email == user.email
      refute invalid_username == user.username
      refute invalid_email == invalid_username
      assert {:error, :invalid_credentials} = should_fail_email
      assert {:error, :invalid_credentials} = should_fail_username
    end

    test "with invalid password", %{params: params} do
      # empty password is invalid
      should_fail_empty =
        params
        |> Map.take([:username])
        |> Map.put(:password, "")
        |> Auth.authenticate_user()

      assert {:error, :invalid_credentials} = should_fail_empty

      # incorrect password is (obviously) invalid
      incorrect_pwd = Faker.String.base64(10)

      should_fail_incorrect =
        params
        |> Map.take([:email])
        |> Map.put(:password, incorrect_pwd)

      refute incorrect_pwd == params.password
      assert {:error, :invalid_credentials} = should_fail_incorrect
    end
  end
end
