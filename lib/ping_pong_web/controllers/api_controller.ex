defmodule PingPongWeb.ApiController do
  use PingPongWeb, :controller

  alias PingPong.Matches
  alias PingPong.{Accounts, Accounts.User}

  def players(conn, _params) do
    json(conn, Accounts.list_users())
  end

  def highscore(conn, _params) do
    json(conn, Accounts.list_users())
  end
end
