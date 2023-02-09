defmodule MaychatWeb.Auth.PipelineAccess do
  use Guardian.Plug.Pipeline,
    otp_app: :maychat,
    error_handler: MaychatWeb.Auth.ErrorHandler,
    module: MaychatWeb.Guardian

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, scheme: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
