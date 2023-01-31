defmodule Maychat.Repo do
  use Ecto.Repo,
    otp_app: :maychat,
    adapter: Ecto.Adapters.Postgres
end
