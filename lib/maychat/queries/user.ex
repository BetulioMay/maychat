defmodule Maychat.Queries.User do
  alias Maychat.Repo
  alias Maychat.Schemas.User

  import Ecto.Query

  def get_user_by_id(id), do: Repo.get(User, id)

  def list_users(), do: Repo.all(User)

  def get_user_by_username_email(username_email) do
    if username_email != nil do
      if is_email?(username_email) do
        Repo.get_by(User, email: username_email)
      else
        Repo.get_by(User, username: username_email)
      end
    else
      nil
    end
  end

  def get_encrypted_pwd!(%User{encrypted_password: encrypted}), do: Base.decode16!(encrypted)

  def get_token_version_by_id(id) do
    query =
      from(u in User,
        where: u.id == ^id,
        select: u.token_version
      )

    Repo.one(query)
  end

  defp is_email?(maybe) do
    changeset = User.email_format(maybe)

    changeset.valid?
  end
end
