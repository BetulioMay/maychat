defmodule MaychatWeb.Plugs.RequestCase do
  alias MaychatWeb.Utils.Case

  def init(opts) do
    %{
      case: opts[:case] || Recase.SnakeCase
    }
  end

  def call(conn, opts) do
    %Plug.Conn{body_params: body_params} = conn

    case body_params do
      %Plug.Conn.Unfetched{} -> conn
      _ -> %{conn | body_params: Case.convert(body_params, opts[:case])}
    end
  end
end
