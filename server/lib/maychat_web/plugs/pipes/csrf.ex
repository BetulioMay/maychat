defmodule MaychatWeb.Plugs.Pipes.CSRF do
  @moduledoc """
  Pipe to generate, store and validate CSRF token in a request
  """
  use Plug.Builder
  import Plug.Conn

  plug(Plug.Session,
    store: :cookie,
    key: "sid",
    # Change this to be an env variable
    encryption_salt: "casldkfjcdjsalkf",
    signing_salt: "alkdjfklasdjc",
    log: :debug
  )

  plug(:fetch_session)
  plug(Plug.CSRFProtection)
  plug(:put_csrf_token_in_session)

  defp put_csrf_token_in_session(conn, _opts) do
    Plug.CSRFProtection.get_csrf_token()
    conn |> put_session("_csrf_token", Process.get(:plug_unmasked_csrf_token))
  end
end
