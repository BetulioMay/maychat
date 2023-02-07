defmodule MaychatWeb.Auth do
  alias Maychat.Contexts.Users

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
end
