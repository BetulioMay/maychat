defmodule Maychat.Schemas.User do
  use Ecto.Schema

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    field(:avatar_url, :string)
  end
end
