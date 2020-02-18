defmodule PingPong.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias PingPong.Accounts.User

  schema "matches" do
    field :started, :utc_datetime
    field :ended, :utc_datetime
    belongs_to :ping, User
    belongs_to :pong, User
    belongs_to :won_by, User

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:started, :ended])
    |> validate_required([:started, :ended])
  end
end
