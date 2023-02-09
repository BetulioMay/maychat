defmodule MaychatWeb.Routes.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router

  alias MaychatWeb.Plugs.{JsonHeader, Pipes.CheckRefreshToken}
  alias MaychatWeb.Controllers.{RegistrationController, SessionController}

  plug(:match)

  plug(CheckRefreshToken, paths: ["/auth/refresh"])

  plug(Plug.Parsers,
    pass: ["text/plain", "application/json"],
    parsers: [{:json, json_decoder: Jason}]
  )

  # plug(VerifyAuthRequest, paths: ~w(/register /login))

  # Always return a JSON object
  plug(JsonHeader)

  plug(:dispatch)

  post("/register", to: RegistrationController)

  post("/login", to: SessionController, init_opts: :login)

  get("/logout", to: SessionController, init_opts: :logout)

  post "/refresh" do
    IO.inspect(Guardian.Plug.current_token(conn))

    conn
    |> send_resp(200, "Refreshing...")
  end

  match _ do
    # TODO: prepare_error_payloads()?? Maybe????
    # Could work if we make kind of a protocol for error
    # normalization.
    # err_payload = %{
    #   success: false,
    #   errors: normalize_string_err("")
    # }
    %Plug.Conn{request_path: req_path} = conn
    raise(MaychatWeb.Router.PathNotFoundError, req_path)
  end
end
