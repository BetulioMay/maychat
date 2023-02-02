defmodule Maychat.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Maychat.Repo,
      {Plug.Cowboy,
       scheme: :http,
       plug: Maychat.Router,
       options: [port: get_cowboy_port(Application.get_env(:maychat, :port))]}
    ]

    opts = [strategy: :one_for_one, name: Maychat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_cowboy_port(port) when is_binary(port) and port != "",
    do: String.to_integer(port)

  defp get_cowboy_port(_), do: 4000
end
