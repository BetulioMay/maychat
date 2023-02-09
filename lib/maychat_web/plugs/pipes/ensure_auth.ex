defmodule MaychatWeb.Plugs.Pipes.EnsureAuth do
  use Plug.Builder

  alias MaychatWeb.Auth.PipelineAccess

  plug(PipelineAccess)
  plug(Guardian.Plug.EnsureAuthenticated)

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: req_path} = conn, opts) do
    if req_path in opts[:paths] do
      conn
      # Don't need paths anymore
      |> super(Keyword.delete(opts, :paths))
    else
      conn
    end
  end
end
