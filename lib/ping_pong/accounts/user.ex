defmodule PingPong.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :tag]}

  schema "users" do
    field :name, :string
    field :tag, Ecto.UUID
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :tag, :rating])
    |> validate_required([:name, :tag])
  end
end
