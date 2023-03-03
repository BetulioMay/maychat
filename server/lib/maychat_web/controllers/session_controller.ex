defmodule MaychatWeb.Controllers.SessionController do
  import Plug.Conn

  alias MaychatWeb.Auth
  alias MaychatWeb.Utils.Errors.NormalizeError
  alias MaychatWeb.Plugs.Redirect

  import MaychatWeb.Utils.Request

  @login_params ~w(username email password remember_me)

  defmodule LoginRequestError do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(err_payload) do
      %__MODULE__{message: Jason.encode!(err_payload)}
    end
  end

  defmodule LogoutRequestError do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(err_payload) do
      %__MODULE__{message: Jason.encode!(err_payload)}
    end
  end

  ## Plug Boilerplate
  def init(opts), do: opts

  # TEST: in case this doesn't work, remove the options and just call login
  # and logout from call as a normal function

  # dispatcher
  @spec call(Plug.Conn.t(), :login | :logout) :: Plug.Conn.t()
  def call(conn, opts)

  def call(conn, :login), do: conn |> login()
  def call(conn, :logout), do: conn |> logout()

  ## Login logic
  defp login(conn) do
    {:ok, login_params, conn} = fetch_params_from_conn(conn, @login_params)

    Auth.authenticate_user(login_params)
    |> login_reply(conn)
  end

  ## Logout logic
  defp logout(conn) do
    # Cookies are already fetched because of CheckRefreshToken middleware
    %Plug.Conn{cookies: cookies} = conn

    Auth.revoke_refresh_token(cookies["jid"])
    |> logout_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, access_token} = Auth.create_access_token(user)
    {:ok, conn, _refresh_token} = Auth.create_and_store_refresh_token(conn, user)

    IO.inspect(conn)

    conn
    |> Redirect.redirect(Path.join(Application.get_env(:maychat, :client_base_url), "/"))
    |> send_resp(
      conn.status || 200,
      Jason.encode!(%{
        success: true,
        access_token: access_token
      })
    )
  end

  defp login_reply({:error, reason}, _) do
    err_payload = %{
      success: false,
      errors: NormalizeError.normalize(reason, :login)
    }

    raise(
      LoginRequestError,
      err_payload
    )
  end

  defp logout_reply({:ok, _claims}, conn) do
    conn
    |> send_resp(
      200,
      Jason.encode!(%{
        success: true
      })
    )
  end

  defp logout_reply({:error, reason}, _) do
    err_payload = %{
      success: false,
      errors: NormalizeError.normalize(reason, "logout")
    }

    raise(LogoutRequestError, err_payload)
  end

  # def login_user(conn) do
  #   {:ok, login_params, conn} = extract_login_params_from_conn(conn)

  #   with {:ok, user} <- validate_user_fetched(login_params[:username_email]),
  #        {:ok, _} <-
  #          validate_password_matching(login_params[:password], Users.get_hashed_pwd!(user)) do
  #     # IDEA: All the logic here for authenticating a user,
  #     # abstract it to use it on register controller too

  #     # Give Access Token and store Refresh Token

  #     payload = %{
  #       access_token: "test",
  #       success: true
  #     }

  #     {conn |> put_status(200), payload}
  #   else
  #     {:error, reason} ->
  #       payload = %{
  #         access_token: nil,
  #         success: false,
  #         errors: %{"login_params" => to_string(reason)}
  #       }
  #       raise(LoginError, Jason.encode!(payload))
  #   end
  # end

  # defp extract_login_params_from_conn(conn) do
  #   %Plug.Conn{
  #     body_params: body_params
  #   } = conn

  #   {:ok,
  #    %{
  #      username_email: body_params["username_email"],
  #      password: body_params["password"]
  #    }, conn}
  # end
end
