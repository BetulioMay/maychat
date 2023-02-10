defmodule MaychatWeb.Auth do
  import Plug.Conn
  alias Maychat.Contexts.Users
  alias MaychatWeb.Guardian

  @access_token_ttl {30, :minutes}
  @refresh_token_ttl {4 * 12, :weeks}

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
    case Guardian.encode_and_sign(user, %{}, ttl: @access_token_ttl) do
      {:ok, access_token, _claims} -> {:ok, access_token}
      error -> error
    end
  end

  def create_and_store_refresh_token(conn, user) do
    # Time-to-live ~= 1 year
    case Guardian.encode_and_sign(user, %{"version" => Users.get_token_version_by_id(user.id)},
           token_type: "refresh",
           ttl: @refresh_token_ttl
         ) do
      {:ok, refresh_token, _claims} ->
        conn = put_refresh_cookie(conn, refresh_token)
        {:ok, conn, refresh_token}

      error ->
        error
    end
  end

  def refresh_refresh_token(conn, refresh_token) do
    case Guardian.refresh(refresh_token, ttl: @refresh_token_ttl) do
      {:ok, _old_stuff, {new_refresh_token, _new_claims}} ->
        put_refresh_cookie(conn, new_refresh_token)

      error ->
        error
    end
  end

  def exchange_refresh_for_access_token(refresh_token) do
    case Guardian.exchange(refresh_token, "refresh", "access", ttl: @access_token_ttl) do
      {:ok, _, {access_token, _claims}} ->
        {:ok, access_token}

      error ->
        error
    end
  end

  @spec revoke_refresh_token(binary) :: {:error, any} | {:ok, map}
  def revoke_refresh_token(refresh_token) do
    Guardian.revoke(refresh_token)
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
