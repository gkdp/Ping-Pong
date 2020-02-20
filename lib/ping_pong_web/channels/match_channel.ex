defmodule PingPongWeb.MatchChannel do
  use PingPongWeb, :channel

  alias PingPong.Matches
  alias PingPong.Matches.Match
  alias PingPong.Repo
  alias Phoenix.Socket

  # Join the lobby and give the active match id as response
  def join("match:lobby", _payload, socket) do
    {:ok, %{match: Matches.get_active_match_id()}, socket}
  end

  # Join the game and give the match details as response
  def join("match:game:" <> match_id, _payload, socket) do
    {match, ping_points, pong_points} = Matches.get_match_with_points(match_id)

    match = %{
      id: match.id,
      started: match.started,
      ended: match.ended,
      won_by: match.won_by,
      serving: (if match.serve_started_by_id, do: Matches.check_serving(match, ping_points + pong_points), else: nil),
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

  # Create a new match with the given players.
  def handle_in("start", %{"players" => %{"ping" => ping, "pong" => pong}}, socket) do
    if Matches.get_active_match_id() do
      {:ok, match} = Matches.create_match(%{
        ping_id: ping,
        pong_id: pong,
        rule_id: 1
      })

      {:reply, {:ok, %{match: match.id}}, socket}
    else
      {:reply, {:error}, socket}
    end
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

  # Handle the point for a match
  def handle_in("serve", %{"for" => type}, %Socket{topic: "match:game:" <> match_id} = socket) do
    match = Matches.get_match!(match_id)

    match
    |> Match.changeset(%{serve_started_by_id: (if type == "ping", do: match.ping_id, else: match.pong_id)})
    |> Repo.update()

    {:noreply, socket}
  end
end
