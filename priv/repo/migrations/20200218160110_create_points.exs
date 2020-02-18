defmodule PingPong.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :match, references(:matches, on_delete: :nothing)
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:points, [:match])
    create index(:points, [:user])
  end
end
