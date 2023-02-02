defmodule Maychat.Controllers.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/register" do
    %Plug.Conn{body_params: _params} = conn

    # Do Register

    conn
  end

  post "/login" do
    # Do Login
    conn
  end
end
