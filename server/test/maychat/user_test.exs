defmodule Maychat.UserTest do
  @moduledoc """
  Test integrity of user's data
  """
  use ExUnit.Case, async: true
  use Maychat.RepoCase

  alias Maychat.Repo
  alias Maychat.Schemas.User
  alias Maychat.Contexts.Users
  alias Maychat.Support.Factory

  # import Ecto.Changeset, only: [change: 2]

  # setup do
  #   on_exit(fn ->
  #     Repo.delete_all(User)
  #   end)
  # end

  describe "create a new user" do
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

    test "with proper username" do
      # Length should be at least 3 and no more than 15
      short = "a"

      params =
        valid_user_params()
        |> Map.update!(:username, fn _ -> short end)

      assert {:error, %Ecto.Changeset{}} = Users.create_user(params)

      long = "prrrrreeeetttttyyyy_looooong_username"
      params = params |> Map.update!(:username, fn _ -> long end)

      assert {:error, %Ecto.Changeset{}} = Users.create_user(params)
    end

    test "with proper avatar url" do
      invalid_url = "google.com"
      params = valid_user_params() |> Map.update!(:avatar_url, fn _ -> invalid_url end)

      assert {:error, _} = Users.create_user(params)
    end
  end

  def create_user(_context), do: {:ok, user: Factory.create(:user)}

  describe "edit a user" do
    setup :create_user

    test "by changing username", %{user: user} do
      %User{username: old} = user
      new = old <> "_new"

      {:ok, updated} = Users.update_user(user, %{username: new})

      assert updated.id == user.id
      assert updated.username != user.username
      assert updated.username == new

      ### Existing username should fail

      IO.inspect(updated, label: ">>> this is the previous")
      IO.inspect(Factory.create(:user), label: ">>> this is the new one")

      assert {:error, %Ecto.Changeset{}} =
               Factory.create(:user)
               |> Users.update_user(%{username: new})
    end

    test "by changing email", %{user: user} do
      new_email = Faker.Internet.email()

      {:ok, updated} = Users.update_user(user, %{email: new_email})

      assert updated.id == user.id
      assert updated.email != user.email
      assert updated.email == new_email
    end

    test "by changing avatar", %{user: user} do
      new_avatar_url = Faker.Internet.image_url() <> ".jpg"

      {:ok, updated} = Users.update_user(user, %{avatar_url: new_avatar_url})

      assert updated.id == user.id
      assert updated.avatar_url != user.avatar_url
      assert updated.avatar_url == new_avatar_url
    end

    test "with empty avatar", %{user: user} do
      {:ok, updated} = Users.update_user(user, %{avatar_url: ""})

      assert updated.id == user.id
      assert updated.avatar_url == nil
    end
  end

  describe "delete a user" do
    setup :create_user

    test "that exists", %{user: %User{id: old_id} = user} do
      {:ok, _deleted} = Users.delete_user(user)

      assert nil == Users.get_user_by_id(old_id)
    end

    test "that doesn't exist", %{user: user} do
      {:ok, user} = Repo.delete(user)

      # Because of how delete/1 works, it doesn't return
      # a changeset, instead it raises a StaleEntryError
      assert_raise Ecto.StaleEntryError, fn -> Users.delete_user(user) end
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
      avatar_url: "http://example.com/cool.png"
    }
  end
end
