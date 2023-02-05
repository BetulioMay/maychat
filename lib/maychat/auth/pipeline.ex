defmodule Maychat.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :maychat,
    error_handler: Maychat.Auth.ErrorHandler,
    module: Maychat.Guardian

  # Token in session?
  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  # Token in header? Bearer?
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  # `Maybe` user
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
