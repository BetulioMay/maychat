defmodule MaychatWeb.Controllers.SessionController do
  import Plug.Conn

  alias MaychatWeb.Auth
  alias MaychatWeb.Guardian

  import MaychatWeb.Utils.Errors
  import MaychatWeb.Utils.Request

  # IDEA: Normalize JSON responses for operations
  # Example:
  # %{
  #   success: boolean,
  #   message: String.t,
  #   ...other info in the form of map. Then Map.merge
  # }

  @params ~w(username email password)

  defmodule LoginRequestError do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(err_payload) do
      %__MODULE__{message: err_payload}
    end
  end

  ## Plug Boilerplate
  def init(opts), do: opts

  # TEST: in case this doesn't work, revoke the options and just call login
  # and logout from call as a normal function

  # `call` is going to be called as a dispatcher
  def call(conn, :login), do: conn |> login()
  def call(conn, :logout), do: conn |> logout()

  ## Login logic
  defp login(conn) do
    {:ok, login_params, conn} = fetch_params_from_conn(conn, @params)

    Auth.authenticate_user(login_params)
    |> login_reply(conn)
  end

  defp logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
    |> send_resp(
      conn.status || 200,
      Jason.encode!(%{
        success: true
      })
    )
  end

  defp login_reply({:ok, user}, conn) do
    # {:ok, token, _claims} =
    #   user
    #   |> Guardian.encode_and_sign()

    conn
    # TODO: Is this correct? Maybe return the payload with the access token
    # for post session auth
    |> send_resp(
      conn.status || 200,
      Jason.encode!(%{
        success: true,
        user_id: user.id
      })
    )
  end

  defp login_reply({:error, reason}, _) do
    raise(
      LoginRequestError,
      Jason.encode!(%{
        success: false,
        errors: normalize_atom_err(reason)
      })
    )
  end

  # def login_user(conn) do
  #   {:ok, login_params, conn} = extract_login_params_from_conn(conn)

  #   with {:ok, user} <- validate_user_fetched(login_params[:username_email]),
  #        {:ok, _} <-
  #          validate_password_matching(login_params[:password], Users.get_encrypted_pwd!(user)) do
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
