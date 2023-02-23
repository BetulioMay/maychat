defmodule MaychatWeb.Plugs.ResponseCase do
  @moduledoc """
  Plug to convert JSON body keys into camelCase. Intended to be used in ingress JSONs.

  Highly inspired on https://github.com/malomohq/accent

  This tiny clone is applied on `body_params` instead of `params`
  to be consistent with the API.

  **Recase** library is used as the converter instead of a self made
  converter like Accent does.
  """
  import Plug.Conn
  alias MaychatWeb.Utils.Case

  def init(opts) do
    %{
      case: opts[:case] || Recase.CamelCase,
      json_codec:
        opts[:json_codec] ||
          raise(ArgumentError, "json codec is missing in plug #{__MODULE__}")
    }
  end

  def call(conn, opts) do
    register_before_send(conn, fn conn -> case_before_send(conn, opts) end)
  end

  defp case_before_send(conn, opts) do
    # Jason, Poison...
    codec = opts[:json_codec]
    converter = opts[:case]
    content_type = get_resp_header(conn, "content-type") |> List.first()

    is_json_content = String.contains?(content_type || "", "application/json")

    if is_json_content do
      %Plug.Conn{resp_body: body} = conn

      cased =
        body
        |> codec.decode!()
        |> Case.call(converter)
        |> Jason.encode!()

      %{conn | resp_body: cased}
    else
      # makes no sense to case if it's not a json object
      conn
    end
  end
end
