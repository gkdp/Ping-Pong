defmodule PingPong.Notifications do
  use GenServer
  alias PingPong.{Accounts, Matches, Matches.Match, Repo}

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

    if ended != nil and won_by_id != nil do
      PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "won", %{
        won_by: won_by_id,
        ended_at: ended
      })
    else
      {match, ping_points, pong_points} = Matches.inspect_match(match_id)

      if match.started != nil do
        PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "serve", %{
          serving: Matches.check_serving(match, ping_points + pong_points)
        })
      else
        PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "reduce", %{
          type: "UPDATE_MATCH_PLAYERS",
          payload: %{
            players: %{
              ping: match.ping,
              pong: match.pong
            }
          }
        })
      end
    end

    {:noreply, socket}
  end

  def handle_info({:notification, _, _, "points_changes", payload}, socket) do
    %{
      "data" => %{
        "match_id" => match_id
      },
      "table" => "points"
    } = Jason.decode!(payload)

    {match, ping_points, pong_points} = Matches.inspect_match(match_id)

    PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "score", %{
      ping: ping_points,
      pong: pong_points
    })

    PingPongWeb.Endpoint.broadcast!("match:game:#{match_id}", "serve", %{
      serving: Matches.check_serving(match, ping_points + pong_points)
    })

    {:noreply, socket}
  end
end
