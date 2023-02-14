defmodule MaychatWeb.Plugs.JsonHeader do
  @moduledoc """
  Put Content-Type JSON for connection
  """
  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _opts), do: conn |> put_resp_content_type("application/json")
end
