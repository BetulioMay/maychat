defmodule MaychatWeb.Plugs.Pipes.CheckRefreshToken do
  import Plug.Conn
  alias MaychatWeb.Guardian

  # TODO: amend this to use a Guardian.Plug.Pipeline instead
  # so Guardian.Pipeline can be used

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: req_path} = conn, opts) do
    if req_path in opts[:paths] do
      conn
      |> fetch_cookies()
      |> verify_and_assign_refresh_token(opts)
    else
      conn
    end
  end

  defp verify_and_assign_refresh_token(%Plug.Conn{cookies: cookies} = conn, opts) do
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
    end
  end
end
