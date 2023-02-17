defmodule MaychatWeb.Routes.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router

  alias MaychatWeb.Plugs.Pipes.EnsureAuth
  alias MaychatWeb.Plugs.{JsonHeader, CheckRefreshToken}
  alias MaychatWeb.Controllers.{RegistrationController, SessionController, RefreshTokenController}

  plug(:match)
  plug(CheckRefreshToken, paths: ["/auth/refresh", "/auth/logout"])
  plug(EnsureAuth, paths: ["/auth/logout"])

  plug(Plug.Parsers,
    pass: ["text/plain", "application/json"],
    parsers: [{:json, json_decoder: Jason}]
  )

  # plug(VerifyAuthRequest, paths: ~w(/register /login))
  # Always return a JSON object
  plug(JsonHeader)
  plug(:dispatch)

  # Endpoints

  post("/register", to: RegistrationController)

  post("/login", to: SessionController, init_opts: :login)

  get("/logout", to: SessionController, init_opts: :logout)

  # piped through CheckRefreshToken
  post("/refresh", to: RefreshTokenController)

  match _ do
    %Plug.Conn{request_path: req_path} = conn
    raise(MaychatWeb.Router.PathNotFoundError, req_path)
  end
end
