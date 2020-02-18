defmodule PingPong.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :tag, :uuid

      timestamps()
    end

  end
end
