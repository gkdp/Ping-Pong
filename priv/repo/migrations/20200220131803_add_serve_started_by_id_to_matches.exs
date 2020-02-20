defmodule PingPong.Repo.Migrations.AddServeStartedByIdToMatches do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :serve_started_by_id, references(:users, on_delete: :nothing)
    end

    create index(:matches, [:serve_started_by_id])
  end
end
