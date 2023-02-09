defmodule MaychatWeb.Routes.User do
  @moduledoc """
  User API REST Route.
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  match _ do
    %Plug.Conn{request_path: req_path} = conn
    raise(MaychatWeb.Router.PathNotFoundError, req_path)
  end
end
