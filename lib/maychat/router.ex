defmodule Maychat.Router do
  @moduledoc false

  use Plug.Router

  alias Maychat.Routes
  alias Maychat.Controllers.Auth

  if Mix.env() == :dev do
    use Plug.Debugger

    plug(Plug.Logger, log: :debug)
  else
    plug(Plug.Logger, log: :info)
  end

  plug(:match)
  plug(:dispatch)

  forward("/auth", to: Auth)
  forward("/user", to: Routes.User)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
