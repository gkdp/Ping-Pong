defmodule PingPong.Championships.Rule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rules" do
    field :label, :string
    field :maximum, :integer
    field :serving, :integer

    timestamps()
  end

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, [:label, :maximum, :serving])
    |> validate_required([:label, :maximum, :serving])
  end
end
