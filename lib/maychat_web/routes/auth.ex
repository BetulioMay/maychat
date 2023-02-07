defmodule MaychatWeb.Routes.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router

  alias MaychatWeb.Plugs.{JsonHeader}
  alias MaychatWeb.Controllers.{RegistrationController, SessionController}

  plug(:match)

  plug(Plug.Parsers,
    pass: ["text/plain", "application/json"],
    parsers: [{:json, json_decoder: Jason}]
  )

  # plug(VerifyAuthRequest, paths: ~w(/register /login))

  # Always return a JSON object
  plug(JsonHeader)

  plug(:dispatch)

  # TODO: Make authentication pipeline

  post("/register", to: RegistrationController)

  post("/login", to: SessionController, init_opts: :login)

  get("/logout", to: SessionController, init_opts: :logout)

  match _ do
    # TODO: prepare_error_payloads()?? Maybe????
    # Could work if we make kind of a protocol for error
    # normalization.
    # err_payload = %{
    #   success: false,
    #   errors: normalize_string_err("")
    # }
    raise(MaychatWeb.Router.EndpointNotFoundError, conn.path)

    # Avoid annoying warning because of unused conn
    conn
  end
end
