defmodule MaychatWeb.Guardian do
  @moduledoc """
  Guardian implementation. Encode/Decode resources with JWT

  The resource in which this implementation is based is the user id,
  to authenticate the users.

  This module must be named differently in case of needing another
  implementation of Guardian.
  """
  use Guardian, otp_app: :maychat

  alias Maychat.Schemas.User
  alias Maychat.Contexts.Users

  # Fetches the user.id as the subject, for the access token
  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  # Fetches the user (resource) from the claims in token
  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user_by_id(id) do
      nil ->
        {:error, :resource_not_found}

      user ->
        {:ok, user}
    end
  end

  def resource_from_claims(_claims), do: {:error, :missing_subject}

  def on_revoke(%{"sub" => id} = claims, _token, _options) do
    with %User{} = user <- Users.get_user_by_id(id),
         {:ok, _user} <- Users.increment_token_version(user) do
      {:ok, claims}
    else
      nil -> {:error, "resource not found"}
      error -> error
    end
  end
end
