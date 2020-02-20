defmodule PingPongWeb.UserControllerTest do
  use PingPongWeb.ConnCase

  alias PingPong.Users

  @create_attrs %{}
  @upuserte_attrs %{}
  @invalid_attrs %{}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New Da"
    end
  end

  describe "create user" do
    test "redirects to show when userta is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Da"
    end

    test "renders errors when userta is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Da"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
