defmodule PingPong.MatchesTest do
  use PingPong.DataCase

  alias PingPong.Matches

  describe "matches" do
    alias PingPong.Matches.Match

    @valid_attrs %{ended: "2010-04-17T14:00:00Z", started: "2010-04-17T14:00:00Z"}
    @update_attrs %{ended: "2011-05-18T15:01:01Z", started: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{ended: nil, started: nil}

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Matches.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = Matches.create_match(@valid_attrs)
      assert match.ended == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert match.started == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, %Match{} = match} = Matches.update_match(match, @update_attrs)
      assert match.ended == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert match.started == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end

  describe "points" do
    alias PingPong.Matches.Point

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def point_fixture(attrs \\ %{}) do
      {:ok, point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Matches.create_point()

      point
    end

    test "list_points/0 returns all points" do
      point = point_fixture()
      assert Matches.list_points() == [point]
    end

    test "get_point!/1 returns the point with given id" do
      point = point_fixture()
      assert Matches.get_point!(point.id) == point
    end

    test "create_point/1 with valid data creates a point" do
      assert {:ok, %Point{} = point} = Matches.create_point(@valid_attrs)
    end

    test "create_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_point(@invalid_attrs)
    end

    test "update_point/2 with valid data updates the point" do
      point = point_fixture()
      assert {:ok, %Point{} = point} = Matches.update_point(point, @update_attrs)
    end

    test "update_point/2 with invalid data returns error changeset" do
      point = point_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_point(point, @invalid_attrs)
      assert point == Matches.get_point!(point.id)
    end

    test "delete_point/1 deletes the point" do
      point = point_fixture()
      assert {:ok, %Point{}} = Matches.delete_point(point)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_point!(point.id) end
    end

    test "change_point/1 returns a point changeset" do
      point = point_fixture()
      assert %Ecto.Changeset{} = Matches.change_point(point)
    end
  end
end
