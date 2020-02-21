defmodule PingPong.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias PingPong.Accounts.User
  alias PingPong.Championships.Rule

  @derive {Jason.Encoder, only: [:id, :started, :ended]}

  schema "matches" do
    field :started, :naive_datetime
    field :ended, :naive_datetime
    belongs_to :rule, Rule
    belongs_to :ping, User
    belongs_to :pong, User
    belongs_to :won_by, User
    belongs_to :serve_started_by, User

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:started, :ended, :ping_id, :pong_id, :won_by_id, :rule_id, :serve_started_by_id])
    |> validate_required([])
  end
end
