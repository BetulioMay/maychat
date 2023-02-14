defmodule MaychatWeb.Utils.Request do
  @moduledoc """
  Utils for dealing with Plug.Conn requests
  """

  @doc """
  Fetches params from a conn given a list of keys.
  """
  @spec fetch_params_from_conn(Plug.Conn.t(), list(String.t())) ::
          {:ok, %{String.t() => any()}, Plug.Conn.t()}
  def fetch_params_from_conn(conn, params) when is_list(params) do
    # body_params = %{
    #   "test1" => "test1",
    #   "test2" => 1000,
    #   "test3" => %{"test3_1" => ["test", "hello"]}
    # }
    %Plug.Conn{
      body_params: body_params
    } = conn

    {:ok,
     body_params
     |> Map.take(params), conn}
  end
end
