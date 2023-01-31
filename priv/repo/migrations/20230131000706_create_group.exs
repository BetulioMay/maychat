defmodule Maychat.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :description, :text
      add :avatar_url, :string, null: true
      add :max_capacity, :integer, default: 100

      timestamps()
    end
  end
end
