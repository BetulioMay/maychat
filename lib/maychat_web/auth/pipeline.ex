defmodule MaychatWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :maychat,
    error_handler: MaychatWeb.Auth.ErrorHandler,
    module: MaychatWeb.Guardian

  # Token in session?
  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  # Token in header? Bearer?
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, scheme: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  # `Maybe` user
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
