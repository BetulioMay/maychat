defmodule Maychat.Repo.Migrations.RememberUserSession do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :remember_me, :boolean, default: false
    end
  end
end
