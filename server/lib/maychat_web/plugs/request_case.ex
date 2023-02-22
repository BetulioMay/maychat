defmodule MaychatWeb.Plugs.RequestCase do
  @moduledoc """
  Plug to convert JSON body keys into snake_case.

  Highly inspired on https://github.com/malomohq/accent

  This tiny clone is applied on `body_params` instead of `params`
  to be consistent with the API.

  **Recase** library is used as the converter instead of a self made
  converter like Accent does.
  """
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
