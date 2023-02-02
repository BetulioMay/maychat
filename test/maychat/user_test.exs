defmodule Maychat.UserTest do
  use ExUnit.Case, async: true

  alias Maychat.Repo
  alias Maychat.Schemas.User
  alias Maychat.Contexts.Users

  setup do
    on_exit(fn ->
      Repo.delete_all(User)
    end)
  end

  describe "Registration" do
    test "register a new user with valid information" do
      # Pre-count of users before registration
      pre_count = count_of(User)

      # Get valid parameters for insert
      user_params = valid_user_params()

      # Insert user
      result = Users.register(user_params)

      # Check count
      post_count = count_of(User)

      # Assert results
      assert {:ok, %User{}} = result
      assert pre_count + 1 == post_count
    end

    test "register a new user with invalid information" do
      pre_count = count_of(User)

      # Make the params dirty by modifying the email to an invalid one
      user_params =
        valid_user_params()
        |> Map.update!(:email, fn _ -> "cesarmay" end)

      # Naively try insert the user
      result = Users.register(user_params)

      post_count = count_of(User)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == post_count
    end

    test "register a new user with existing email/username" do
      params = valid_user_params()

      # Previously insert an user with the same email and same username
      # other info can be repeated
      Users.register(params)

      pre_count = count_of(User)

      # Cluelessly try to insert the user with same info
      result = Users.register(params)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == count_of(User)

      # Check if the same happens for only the email
      only_email =
        params
        |> Map.update!(:username, fn _ -> "rms" end)
        |> Users.register()

      assert {:error, _} = only_email

      # Likewise with username
      only_username =
        params
        |> Map.update!(:email, fn _ -> "root@root.com" end)
        |> Users.register()

      assert {:error, _} = only_username

      assert pre_count == count_of(User)
    end

    test "register user without matching passwords" do
      pre_count = count_of(User)

      # Invalid passwords
      params =
        valid_user_params()
        |> Map.update!(:password_confirmation, fn _ -> "superdupersecret" end)

      result = Users.register(params)

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
