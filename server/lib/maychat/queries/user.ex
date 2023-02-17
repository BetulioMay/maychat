defmodule Maychat.Queries.User do
  alias Maychat.Repo
  alias Maychat.Schemas.User

  import Ecto.Query

  def get_user_by_id(id), do: Repo.get(User, id)

  def list_users(), do: Repo.all(User)

  def get_user_by_username_email(username_email) do
    if !username_email do
      nil
    else
      if is_email?(username_email) do
        Repo.get_by(User, email: username_email)
      else
        Repo.get_by(User, username: username_email)
      end
    end
  end

  @spec get_hashed_pwd!(User.t()) :: binary()
  def get_hashed_pwd!(%User{password_hash: hashed}), do: Base.decode16!(hashed)

  def get_token_version_by_id!(id) do
    query =
      from(u in User,
        where: u.id == ^id,
        select: u.token_version
      )

    Repo.one!(query)
  end

  defp is_email?(maybe) do
    changeset = User.email_format(maybe)

    changeset.valid?
  end
end
