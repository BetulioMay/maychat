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
  import Ecto.Query
  alias MaychatWeb.Auth
  alias MaychatWeb.Guardian
  alias Maychat.Contexts.Users

  def init(opts), do: opts

  def call(conn, _opts), do: conn |> refresh()

  defp refresh(conn) do
    # NOTE: this could be accessed directly from the cookie
    %Plug.Conn{assigns: %{refresh_token: refresh_token}} = conn

    %{claims: %{"version" => token_version, "sub" => user_id}} = Guardian.peek(refresh_token)

    current_version = get_current_token_version!(user_id)

    # TODO: Change this
    query = from(u in Maychat.Schemas.User, where: u.id == ^user_id, select: u.remember_me)

    remember_me = Maychat.Repo.one!(query)

    if token_version != current_version do
      raise(InvalidTokenVersion, "token version is invalid")
    end

    {:ok, access_token} = Auth.exchange_refresh_for_access_token(refresh_token)

    # Refresh token will always be valid if the user keep using the API
    # or the token is invalidated, unless remember me preference is off
    conn =
      if remember_me,
        do: Auth.refresh_refresh_token(conn, refresh_token),
        else: conn

    conn
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
