defmodule MaychatWeb.Controllers.RefreshTokenController do
  alias MaychatWeb.Utils.Errors.NormalizeError

  defmodule InvalidTokenVersion do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(msg) do
      err_payload = %{
        success: false,
        errors: NormalizeError.normalize(msg, "token_version")
      }

      %__MODULE__{message: Jason.encode!(err_payload)}
    end
  end

  defmodule ResourceNotFound do
    defexception [:message, plug_status: 400]

    @impl true
    def exception(msg) do
      err_payload = %{
        success: false,
        errors: NormalizeError.normalize(msg, "token_subject")
      }

      %__MODULE__{message: Jason.encode!(err_payload)}
    end
  end

  import Plug.Conn
  alias MaychatWeb.Auth
  alias MaychatWeb.Guardian
  alias Maychat.Contexts.Users

  def init(opts), do: opts

  def call(conn, _opts), do: conn |> refresh()

  defp refresh(conn) do
    %Plug.Conn{assigns: %{refresh_token: refresh_token}} = conn

    %{claims: %{"version" => token_version, "sub" => user_id}} = Guardian.peek(refresh_token)

    current_version = get_current_token_version!(user_id)

    if token_version != current_version do
      raise(InvalidTokenVersion, "token version is invalid")
    end

    IO.inspect(token_version, label: "JID version")
    IO.inspect(current_version, label: "Current token version")

    {:ok, access_token} = Auth.exchange_refresh_for_access_token(refresh_token)

    conn
    # Refresh token will always be valid if the user keep using the API
    # or the token is invalidated
    |> Auth.refresh_refresh_token(refresh_token)
    |> send_resp(
      200,
      Jason.encode!(%{
        success: true,
        access_token: access_token
      })
    )
  end

  defp get_current_token_version!(id) do
    try do
      Users.get_token_version_by_id!(id)
    rescue
      Ecto.NoResultsError -> raise(ResourceNotFound, "resource not found")
      _e -> raise("Unexpected error")
    else
      current_version -> current_version
    end
  end
end
