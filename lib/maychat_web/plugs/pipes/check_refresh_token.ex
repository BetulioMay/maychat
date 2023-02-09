defmodule MaychatWeb.Plugs.Pipes.CheckRefreshToken do
  use Plug.Builder
  alias MaychatWeb.Guardian

  # TODO: amend this to use a Guardian.Plug.Pipeline instead
  plug(:load_cookies)
  plug(:verify_refresh_token)

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: req_path} = conn, opts) do
    if req_path in opts[:paths] do
      conn
      |> super(Keyword.delete(opts, :paths))
    else
      conn
    end
  end

  defp load_cookies(conn, _opts), do: fetch_cookies(conn)

  defp verify_refresh_token(%Plug.Conn{cookies: cookies} = conn, opts) do
    %{"jid" => refresh_token} = cookies

    case Guardian.decode_and_verify(refresh_token, %{"typ" => "refresh"}) do
      {:ok, _claims} ->
        conn
        |> assign(:refresh_token, to_string(refresh_token))

      _error ->
        # Ugly way of doing this, I know...
        conn
        |> MaychatWeb.Auth.ErrorHandler.auth_error(
          {:unauthenticated, "refresh token is invalid"},
          opts
        )
        # Do not resend
        |> halt()
    end
  end
end
