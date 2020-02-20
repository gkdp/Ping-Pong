defmodule PingPong.UsersTest do
  use PingPong.UsertaCase

  alias PingPong.Users

  describe "users" do
    alias PingPong.Users.User

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def da_fixture(attrs \\ %{}) do
      {:ok, da} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_da()

      da
    end

    test "list_users/0 returns all users" do
      da = da_fixture()
      assert Users.list_users() == [da]
    end

    test "get_da!/1 returns the da with given id" do
      da = da_fixture()
      assert Users.get_da!(da.id) == da
    end

    test "create_da/1 with valid data creates a da" do
      assert {:ok, %User{} = da} = Users.create_da(@valid_attrs)
    end

    test "create_da/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_da(@invalid_attrs)
    end

    test "update_da/2 with valid data updates the da" do
      da = da_fixture()
      assert {:ok, %User{} = da} = Users.update_da(da, @update_attrs)
    end

    test "update_da/2 with invalid data returns error changeset" do
      da = da_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_da(da, @invalid_attrs)
      assert da == Users.get_da!(da.id)
    end

    test "delete_da/1 deletes the da" do
      da = da_fixture()
      assert {:ok, %User{}} = Users.delete_da(da)
      assert_raise Ecto.NoResultsError, fn -> Users.get_da!(da.id) end
    end

    test "change_da/1 returns a da changeset" do
      da = da_fixture()
      assert %Ecto.Changeset{} = Users.change_da(da)
    end
  end
end
