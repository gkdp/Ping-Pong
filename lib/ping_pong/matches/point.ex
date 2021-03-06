defmodule PingPong.Matches.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias PingPong.Matches.Match
  alias PingPong.Accounts.User

  @derive {Jason.Encoder, only: [:match, :user]}

  schema "points" do
    belongs_to :match, Match
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:match_id, :user_id])
    |> validate_required([])
  end
end
