defmodule PingPong.Repo.Migrations.AddRuleIdToMatches do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :rule_id, references(:rules, on_delete: :nothing)
    end

    create index(:matches, [:rule_id])
  end
end
