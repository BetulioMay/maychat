defmodule MaychatWeb.Plugs.Redirect do
  @moduledoc """
  Redirect middleware.
  """

  import Plug.Conn

  def redirect(conn, url) do
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(302, body)
  end
end
