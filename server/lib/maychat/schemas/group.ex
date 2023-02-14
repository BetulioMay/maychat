defmodule Maychat.Schemas.Group do
  use Ecto.Schema

  schema "groups" do
    field(:name, :string)
    field(:description, :string)
    field(:avatar_url, :string)
    field(:max_capacity, :integer, default: 100)

    timestamps()
  end
end
