defmodule MaychatWeb.Auth do
  import Plug.Conn
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
    case Guardian.encode_and_sign(user, %{}, ttl: {30, :minutes}) do
      {:ok, access_token, _claims} -> {:ok, access_token}
      error -> error
    end
  end

  def create_refresh_token(conn, user) do
    # Time-to-live ~= 1 year
    case Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {4 * 12, :weeks}) do
      {:ok, refresh_token, _claims} ->
        conn = put_refresh_cookie(conn, refresh_token)
        {:ok, conn, refresh_token}

      error ->
        error
    end
  end

  defp put_refresh_cookie(conn, refresh_token) do
    conn
    |> put_resp_cookie(
      "jid",
      refresh_token,
      http_only: true,
      same_site: false,
      secure: true,
      max_age: 24 * 60 * 60 * 1000
    )
  end

  def get_resource_from_conn(conn), do: conn |> Guardian.Plug.current_resource()
end
