defmodule PingPong.Repo.Migrations.AddRatingToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :rating, :integer, default: 1000
    end
  end
end
