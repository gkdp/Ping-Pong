defmodule PingPong.Notifications do
  use GenServer
  alias PingPong.{Matches, Matches.Match, Repo}

  def start_link(channel) do
    GenServer.start_link(__MODULE__, channel)
  end

  def init(channel) do
    {:ok, pid} =
      Application.get_env(:ping_pong, PingPong.Repo)
      |> Postgrex.Notifications.start_link()

    ref = Postgrex.Notifications.listen!(pid, channel)

    {:ok, {pid, ref, channel}}
  end

  def handle_info({:notification, _, _, "matches_changes", payload}, socket) do
    %{
      "data" => %{
        "id" => match_id,
        "ended" => ended,
        "won_by_id" => won_by_id
      },
      "table" => "matches"
    } = Jason.decode!(payload)

    PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "won", %{
      won_by: won_by_id,
      ended_at: ended
    })

    {:noreply, socket}
  end

  def handle_info({:notification, _, _, "points_changes", payload}, socket) do
    %{
      "data" => %{
        "match_id" => match_id
      },
      "table" => "points"
    } = Jason.decode!(payload)

    {_, ping_points, pong_points} = Matches.inspect_match(match_id)

    PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "score", %{
      ping: ping_points,
      pong: pong_points
    })

    {:noreply, socket}
  end
end
