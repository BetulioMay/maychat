defmodule Maychat.Schemas.User do
  use Ecto.Schema

  import Ecto.Changeset

  @email_pattern ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  @image_url_pattern ~r/(https?:\/\/.*\.(?:png|jpg|jpeg))/i

  @type t :: %__MODULE__{
          id: integer(),
          username: String.t(),
          email: String.t(),
          encrypted_password: String.t(),
          avatar_url: String.t(),
          token_version: integer(),
          remember_me: boolean()
        }

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:encrypted_password, :string)
    field(:avatar_url, :string)
    field(:token_version, :integer)
    field(:remember_me, :boolean, default: false)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:username, :email, :password, :avatar_url, :remember_me])
    |> validate_required([:username, :email, :password])
    |> validate_confirmation(:password, required: true)
    |> validate_format(:email, @email_pattern)
    |> validate_format(:avatar_url, @image_url_pattern)
    |> validate_length(:username, min: 3, max: 30)
    |> unique_constraint([:username])
    |> unique_constraint([:email])
    |> put_encrypted_password()
  end

  # TODO: Make user be able to change their passwords
  def edit_changeset(struct, params) do
    struct
    |> cast(params, [
      :username,
      :email,
      :password,
      :avatar_url,
      :remember_me
    ])
    |> validate_required([:username, :email])
    |> validate_format(:email, @email_pattern)
    |> validate_format(:avatar_url, @image_url_pattern)
    |> validate_length(:username, min: 3, max: 30)
    |> unique_constraint([:username])
    |> unique_constraint([:email])
    |> put_encrypted_password()
  end

  def email_format(email) do
    %__MODULE__{}
    |> change(%{email: email})
    |> validate_format(:email, @email_pattern)
  end

  defp put_encrypted_password(
         %Ecto.Changeset{valid?: true, changes: %{password: plain_pwd}} = changeset
       )
       when not is_nil(plain_pwd) do
    put_change(
      changeset,
      :encrypted_password,
      Argon2.hash_pwd_salt(plain_pwd) |> Base.encode16()
    )
  end

  defp put_encrypted_password(changeset), do: changeset
end
