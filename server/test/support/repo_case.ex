defmodule Maychat.RepoCase do
  # see https://hexdocs.pm/ecto/3.9.3/testing-with-ecto.html
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Maychat.Repo

      import Ecto
      import Ecto.Query
      import Maychat.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    # checks for a database connection
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Maychat.Repo)

    # if sync tests, then use only one connection
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Maychat.Repo, {:shared, self()})
    end

    :ok
  end
end
