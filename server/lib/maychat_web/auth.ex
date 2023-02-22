defmodule MaychatWeb.Auth do
  import Plug.Conn
  alias Maychat.Contexts.Users
  alias Maychat.Schemas.User
  alias MaychatWeb.Guardian

  @access_token_ttl {15, :seconds}
  @refresh_token_ttl {4 * 12, :weeks}
  @refresh_token_id "jid"

  # TODO: change params["<param>"] || params[:<params>] to be normalized,
  # use Functors or so to map string keys into atom keys or viceversa.

  @doc """
  Authenticates a user given its login params.
  """
  @spec authenticate_user(%{String.t() => any()}) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
  def authenticate_user(params) do
    params = normalize_params(params)

    username_email = if params["email"], do: params["email"], else: params["username"]
    choose_remember_me = params["remember_me"]

    case Users.get_user_by_username_email(username_email) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      %User{} = user ->
        if Argon2.verify_pass(params["password"], Users.get_hashed_pwd!(user)) do
          if user.remember_me != choose_remember_me do
            # Update user.remember_me
            {:ok, updated} =
              Users.update_user(
                user,
                %{remember_me: choose_remember_me}
              )

            {:ok, updated}
          else
            {:ok, user}
          end
        else
          {:error, :invalid_credentials}
        end
    end
  end

  # defp normalize_params(params) do
  #   params
  #   |> Enum.map(fn {k, v} -> {to_string(k), v} end)
  #   |> Enum.into(%{})
  # end

  defp normalize_params(params) do
    for {k, v} <- params, into: %{} do
      {to_string(k), v}
    end
  end

  def create_access_token(user) do
    case Guardian.encode_and_sign(user, %{}, ttl: @access_token_ttl) do
      {:ok, access_token, _claims} -> {:ok, access_token}
      error -> error
    end
  end

  def create_and_store_refresh_token(conn, user = %User{}) do
    # Time-to-live ~= 1 year
    case Guardian.encode_and_sign(
           user,
           %{"version" => Users.get_token_version_by_id!(user.id)},
           token_type: "refresh",
           ttl: @refresh_token_ttl
         ) do
      {:ok, refresh_token, _claims} ->
        {
          :ok,
          put_refresh_cookie(conn, refresh_token, user.remember_me),
          refresh_token
        }

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
    case Guardian.exchange(
           refresh_token,
           "refresh",
           "access",
           ttl: @access_token_ttl
         ) do
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

  defp put_refresh_cookie(conn, refresh_token, remember \\ true) do
    max_age = if remember, do: 24 * 60 * 60 * 1000, else: 2 * 60 * 60

    conn
    |> put_resp_cookie(
      @refresh_token_id,
      refresh_token,
      http_only: true,
      same_site: false,
      secure: true,
      max_age: max_age
    )
  end

  # def get_resource_from_conn(conn), do: conn |> Guardian.Plug.current_resource()
end
