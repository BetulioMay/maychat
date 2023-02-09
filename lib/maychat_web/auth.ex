defmodule MaychatWeb.Auth do
  alias Maychat.Contexts.Users
  alias MaychatWeb.Guardian

  def authenticate_user(params) do
    username_email = if params["email"], do: params["email"], else: params["username"]

    case Users.get_user_by_username_email(username_email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(params["password"], Users.get_encrypted_pwd!(user)) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def create_access_token(user) do
    {:ok, access_token, _claims} = Guardian.encode_and_sign(user, %{}, ttl: {30, :minutes})
    access_token
  end

  def create_refresh_token(user) do
    case Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {4 * 12, :weeks}) do
      {:ok, refresh_token, _claims} -> refresh_token
      error -> error
    end
  end
end
