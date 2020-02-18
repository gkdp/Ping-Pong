defmodule PingPong.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :tag, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :tag])
    |> validate_required([:name, :tag])
  end
end
