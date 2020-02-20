defmodule PingPongWeb.ApiView do
  use PingPongWeb, :view
  alias PingPongWeb.ApiView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, ApiView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, ApiView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name}
  end
end
