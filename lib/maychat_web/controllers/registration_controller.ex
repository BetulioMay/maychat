defmodule MaychatWeb.Controllers.RegistrationController do
  require Logger

  alias MaychatWeb.Controllers.SessionController
  alias Maychat.Contexts.Users
  alias Maychat.Schemas.User

  import MaychatWeb.Utils.Errors
  import MaychatWeb.Utils.Request

  @params ~w(username email password password_confirmation avatar_url)

  defmodule RegistrationRequestError do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(err_payload) do
      %__MODULE__{message: err_payload}
    end
  end

  # Plug boilerplate
  def init(opts), do: opts
  def call(conn, _opts), do: conn |> register

  defp register(conn) do
    {:ok, reg_params, conn} = fetch_params_from_conn(conn, @params)

    Logger.info("Received body_params #{inspect(conn.body_params)}")

    case Users.create_user(reg_params) do
      {:ok, %User{id: id}} ->
        Logger.info("user registered with id: #{id}")

        # User has been created, now let the session controller
        # handle the later user login
        conn
        |> SessionController.call(:login)

      # payload = %{
      #   access_token: nil,
      #   success: true
      # }

      # conn
      # |> send_resp(200, Jason.encode!(payload))

      {:error, %Ecto.Changeset{errors: errors} = changeset} ->
        # Remember removing this
        Logger.error("Error on Users.register/1: #{inspect(errors)}")

        if not changeset.valid? do
          # errors_map = %{
          #   errors:
          #     changeset
          #     |> Ecto.Changeset.traverse_errors(fn {msg, _opts} ->
          #       msg
          #     end)
          # }

          payload = %{
            success: false,
            errors:
              changeset
              |> normalize_changeset_err()
          }

          raise(RegistrationRequestError, Jason.encode!(payload))
        end
    end
  end
end
