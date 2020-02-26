defmodule PingPong.Repo.Migrations.AddDifferenceToRules do
  use Ecto.Migration

  def change do
    alter table(:rules) do
      add :difference, :integer
    end
  end
end
