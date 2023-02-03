defmodule MaychatWeb.Routes.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  # TODO: Make these routes call the appropiate controllers
  # TODO: Make JWT Authentication

  post "/register" do
    # Do Register
    IO.inspect(conn)
    conn
  end

  post "/login" do
    # Do Login
    conn
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
