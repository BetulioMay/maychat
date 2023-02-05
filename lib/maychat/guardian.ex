defmodule Maychat.Guardian do
  @moduledoc """
  Guardian implementation. Encode/Decode resources with JWT

  The resource in which this implementation is based is the user id,
  to authenticate the users.

  This module must be named differently in case of the need of another
  implementation of Guardian.
  """
  use Guardian, otp_app: :maychat

  alias Maychat.Schemas.User
  alias Maychat.Contexts.Users

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user_by_id(id) do
      nil ->
        {:error, :resource_not_found}

      user ->
        {:ok, user}
    end
  end
end
