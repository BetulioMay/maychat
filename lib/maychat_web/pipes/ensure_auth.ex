defmodule MaychatWeb.Pipes.EnsureAuth do
  use Plug.Builder

  alias MaychatWeb.Auth

  plug(Auth.Pipeline)
  plug(Guardian.Plug.EnsureAuthenticated)

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: req_path} = conn, opts) do
    if req_path in opts[:paths] do
      conn
      |> super(opts)
    else
      conn
    end
  end
end
