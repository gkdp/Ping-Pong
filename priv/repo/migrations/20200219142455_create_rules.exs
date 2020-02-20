defmodule PingPong.Repo.Migrations.CreateRules do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :label, :string
      add :maximum, :integer
      add :serving, :integer

      timestamps()
    end

  end
end
