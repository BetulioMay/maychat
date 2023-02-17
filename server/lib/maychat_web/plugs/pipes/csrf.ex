defmodule MaychatWeb.Plugs.Pipes.CSRF do
  @moduledoc """
  Pipe to generate, store and validate CSRF token in a request
  """
  use Plug.Builder
  import Plug.Conn

  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_sid",
    # Change this to be an env variable
    encryption_salt: "casldkfjcdjsalkfdssafdlfds",
    signing_salt: "alkdjfklasdjcadfjasdkfjasdh",
    log: :debug
  )

  plug(:fetch_session)
  plug(:put_csrf_token_in_session)
  plug(Plug.CSRFProtection)

  defp put_csrf_token_in_session(conn, _opts) do
    conn
    |> put_req_header("x-csrf-token", Plug.CSRFProtection.get_csrf_token())
    |> put_session("_csrf_token", Process.get(:plug_unmasked_csrf_token))
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "d5b2hHZGsUfcYB8lImcxooaLfVBlB5bg/z9a99jjHuXTvt7yb5neykHrYEjuNFnD"
    )
  end
end
