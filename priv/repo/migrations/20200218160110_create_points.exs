defmodule PingPong.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :match_id, references(:matches, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:points, [:match_id])
    create index(:points, [:user_id])
  end
end
