defmodule PingPongWeb.PageController do
  use PingPongWeb, :controller

  alias PingPong.Matches

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
