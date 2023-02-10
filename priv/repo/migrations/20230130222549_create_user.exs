defmodule Maychat.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :encrypted_password, :string
      add :avatar_url, :string
      add :token_version, :integer, default: 0

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
