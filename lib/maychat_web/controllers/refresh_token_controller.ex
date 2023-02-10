defmodule MaychatWeb.Controllers.RefreshTokenController do
  import Plug.Conn
  alias MaychatWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts), do: conn |> refresh()

  defp refresh(conn) do
    %Plug.Conn{assigns: %{refresh_token: refresh_token}} = conn

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
end
