defmodule PingPong.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :started, :utc_datetime, default: fragment("now()")
      add :ended, :utc_datetime
      add :ping, references(:users, on_delete: :nothing), null: false
      add :pong, references(:users, on_delete: :nothing), null: false
      add :won_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:matches, [:ping])
    create index(:matches, [:pong])
    create index(:matches, [:won_by])
  end
end
