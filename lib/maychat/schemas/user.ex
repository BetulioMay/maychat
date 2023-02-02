defmodule Maychat.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:encrypted_password, :string)
    field(:avatar_url, :string)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:username, :email, :password, :avatar_url])
    |> validate_required([:username, :email, :password])
    |> validate_confirmation(:password, required: true)
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    |> unique_constraint([:username])
    |> unique_constraint([:email])
    |> put_encrypted_password()
  end

  defp put_encrypted_password(
         %Ecto.Changeset{valid?: true, changes: %{password: plain_pwd}} = changeset
       ) do
    put_change(changeset, :encrypted_password, Argon2.hash_pwd_salt(plain_pwd) |> Base.encode16())
  end

  defp put_encrypted_password(changeset), do: changeset
end
