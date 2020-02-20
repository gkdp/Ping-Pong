defmodule PingPongWeb.MatchChannel do
  use PingPongWeb, :channel

  alias PingPong.Matches
  alias PingPong.Matches.Match
  alias Phoenix.Socket

  def join("match:lobby", _payload, socket) do
    {:ok, %{match: Matches.get_active_match_id()}, socket}
  end

  def join("match:game:" <> match_id, _payload, socket) do
    {match, ping_points, pong_points} = Matches.get_match_with_points(match_id)

    match = %{
      id: match.id,
      started: match.started,
      ended: match.ended,
      won_by: match.won_by,
      players: %{
        ping: match.ping,
        pong: match.pong
      },
      points: %{
        ping: ping_points,
        pong: pong_points,
      }
    }

    {:ok, %{match: match}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("start", %{"players" => %{"ping" => ping, "pong" => pong}}, socket) do
    {:ok, match} = Matches.create_match(%{
      started: DateTime.utc_now,
      ping_id: ping,
      pong_id: pong,
      rule_id: 1
    })

    {:reply, %{match: match.id}, socket}
  end

  # Handle the point for a match
  def handle_in("point", %{"for" => player}, %Socket{topic: "match:game:" <> match_id} = socket) do
    %Match{ping_id: ping_id, pong_id: pong_id} = Matches.get_match!(match_id)

    case player do
      "ping" ->
        Matches.create_point(%{match_id: match_id, user_id: ping_id})

      "pong" ->
        Matches.create_point(%{match_id: match_id, user_id: pong_id})
    end

    {:noreply, socket}
  end
end
