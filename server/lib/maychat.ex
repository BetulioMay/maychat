defmodule Maychat do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = get_cowboy_port(Application.get_env(:maychat, :port))

    children = [
      Maychat.Repo,
      {Plug.Cowboy, scheme: :http, plug: MaychatWeb.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: Maychat.Supervisor]
    sup = Supervisor.start_link(children, opts)

    Logger.info("Listening on port #{port}...")

    sup
  end

  defp get_cowboy_port(port) when is_binary(port) and port != "",
    do: String.to_integer(port)

  defp get_cowboy_port(_), do: 4000
end
