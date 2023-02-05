defmodule Maychat.AuthTest do
  use ExUnit.Case, async: true

  alias Maychat.Repo
  alias Maychat.Schemas.User
  alias Maychat.Contexts.Users

  setup do
    on_exit(fn ->
      Repo.delete_all(User)
    end)
  end

  @doc """
  User registration module testing.

  Tests against creation process of a new user
  """
  describe "register a new user" do
    test "with valid information" do
      # Pre-count of users before registration
      pre_count = count_of(User)

      # Get valid parameters for insert
      user_params = valid_user_params()

      # Insert user
      result = Users.create_user(user_params)

      # Check count
      post_count = count_of(User)

      # Assert results
      assert {:ok, %User{}} = result
      assert pre_count + 1 == post_count
    end

    test "with invalid information" do
      pre_count = count_of(User)

      # Make the params dirty by modifying the email to an invalid one
      user_params =
        valid_user_params()
        |> Map.update!(:email, fn _ -> "cesarmay" end)

      # Naively try insert the user
      result = Users.create_user(user_params)

      post_count = count_of(User)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == post_count
    end

    test "with existing email/username" do
      params = valid_user_params()

      # Previously insert an user with the same email and same username
      # other info can be repeated
      Users.create_user(params)

      pre_count = count_of(User)

      # Cluelessly try to insert the user with same info
      result = Users.create_user(params)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == count_of(User)

      # Check if the same happens for only the email
      only_email =
        params
        |> Map.update!(:username, fn _ -> "rms" end)
        |> Users.create_user()

      assert {:error, _} = only_email

      # Likewise with username
      only_username =
        params
        |> Map.update!(:email, fn _ -> "root@root.com" end)
        |> Users.create_user()

      assert {:error, _} = only_username

      assert pre_count == count_of(User)
    end

    test "without matching passwords" do
      pre_count = count_of(User)

      # Invalid passwords
      params =
        valid_user_params()
        |> Map.update!(:password_confirmation, fn _ -> "superdupersecret" end)

      result = Users.create_user(params)

      assert {:error, _} = result
      assert pre_count == count_of(User)
    end
  end

  defp count_of(queryable) do
    Repo.aggregate(queryable, :count, :id)
  end

  defp valid_user_params() do
    %{
      username: "cmayora",
      email: "cesar@mayora.com",
      password: "supersecretpwd",
      password_confirmation: "supersecretpwd",
      avatar_url: "http://example.com"
    }
  end
end
