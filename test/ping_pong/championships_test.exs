defmodule PingPong.ChampionshipsTest do
  use PingPong.DataCase

  alias PingPong.Championships

  describe "rules" do
    alias PingPong.Championships.Rule

    @valid_attrs %{label: "some label", maximum: 42, serving: 42}
    @update_attrs %{label: "some updated label", maximum: 43, serving: 43}
    @invalid_attrs %{label: nil, maximum: nil, serving: nil}

    def rule_fixture(attrs \\ %{}) do
      {:ok, rule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Championships.create_rule()

      rule
    end

    test "list_rules/0 returns all rules" do
      rule = rule_fixture()
      assert Championships.list_rules() == [rule]
    end

    test "get_rule!/1 returns the rule with given id" do
      rule = rule_fixture()
      assert Championships.get_rule!(rule.id) == rule
    end

    test "create_rule/1 with valid data creates a rule" do
      assert {:ok, %Rule{} = rule} = Championships.create_rule(@valid_attrs)
      assert rule.label == "some label"
      assert rule.maximum == 42
      assert rule.serving == 42
    end

    test "create_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Championships.create_rule(@invalid_attrs)
    end

    test "update_rule/2 with valid data updates the rule" do
      rule = rule_fixture()
      assert {:ok, %Rule{} = rule} = Championships.update_rule(rule, @update_attrs)
      assert rule.label == "some updated label"
      assert rule.maximum == 43
      assert rule.serving == 43
    end

    test "update_rule/2 with invalid data returns error changeset" do
      rule = rule_fixture()
      assert {:error, %Ecto.Changeset{}} = Championships.update_rule(rule, @invalid_attrs)
      assert rule == Championships.get_rule!(rule.id)
    end

    test "delete_rule/1 deletes the rule" do
      rule = rule_fixture()
      assert {:ok, %Rule{}} = Championships.delete_rule(rule)
      assert_raise Ecto.NoResultsError, fn -> Championships.get_rule!(rule.id) end
    end

    test "change_rule/1 returns a rule changeset" do
      rule = rule_fixture()
      assert %Ecto.Changeset{} = Championships.change_rule(rule)
    end
  end
end
