# Usage:
#   $ iex -S mix
#   maychat> import_file("scripts/test/normalize_errors.exs")

alias MaychatWeb.Utils
alias Maychat.Contexts.Users

# Get a changeset example
{:error, changeset} = Users.update_user(%Maychat.Schemas.User{}, %{username: "cesar"})

changeset |> Utils.Errors.NormalizeError.normalize() |> IO.inspect
