defmodule PingPong.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :started, :naive_datetime
      add :ended, :naive_datetime
      add :ping_id, references(:users, on_delete: :nothing)
      add :pong_id, references(:users, on_delete: :nothing)
      add :won_by_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:matches, [:ping_id])
    create index(:matches, [:pong_id])
    create index(:matches, [:won_by_id])
  end
end
