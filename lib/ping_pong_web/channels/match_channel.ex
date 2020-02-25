defmodule PingPongWeb.MatchChannel do
  use PingPongWeb, :channel

  alias PingPong.Accounts
  alias PingPong.Matches
  alias PingPong.Matches.Match
  alias PingPong.Repo
  alias Phoenix.Socket

  # Join the lobby and give the active match id as response
  def join("match:lobby", _payload, socket) do
    case Matches.get_active_match_id() do
      id when is_integer(id) ->
        {:ok, %{match: id}, socket}

      nil ->
        {:ok, %Match{id: id}} =
          Matches.create_match(%{
            rule_id: 1
          })

        {:ok, %{match: id}, socket}
    end
  end

  # Join the game and give the match details as response
  def join("match:game:" <> match_id, _payload, socket) do
    with {match, ping_points, pong_points} <- Matches.get_match_with_points(match_id) do
      match = %{
        id: match.id,
        started: match.started,
        ended: match.ended,
        won_by: match.won_by,
        serving:
          if(match.serve_started_by_id,
            do: Matches.check_serving(match, ping_points + pong_points),
            else: nil
          ),
        players: %{
          ping: match.ping,
          pong: match.pong
        },
        points: %{
          ping: ping_points,
          pong: pong_points
        },
        information: Matches.get_information(match)
      }

      {:ok, %{match: match}, socket}
    else
      _ ->
        {:ok, %{match: nil}, socket}
    end
  end

  # Create a new match with the given players.
  def handle_in("start", %{"players" => %{"ping" => ping, "pong" => pong}}, socket) do
    if Matches.get_active_match_id() == nil do
      {:ok, %Match{id: id}} =
        Matches.create_match(%{
          ping_id: ping,
          # pong_id: pong,
          rule_id: 1
        })

      {:reply, {:ok, %{match: id}}, socket}
    else
      {:reply, :error, socket}
    end
  end

  # Handle the point for a match
  def handle_in("point", %{"for" => player}, %Socket{topic: "match:game:" <> match_id} = socket) do
    %Match{started: started, ping_id: ping_id, pong_id: pong_id} = Matches.get_match!(match_id)

    if started != nil do
      {id, _} =
        Code.eval_string player,
          ping: ping_id,
          pong: pong_id

      Matches.create_point(%{match_id: match_id, user_id: id})
    end

    {:noreply, socket}
  end

  # Handle the starting serve player
  def handle_in("serve", %{"for" => type}, %Socket{topic: "match:game:" <> match_id} = socket) do
    match = Matches.get_match!(match_id)

    started = NaiveDateTime.utc_now

    match
    |> Match.changeset(%{
      started: started,
      serve_started_by_id: if(type == "ping", do: match.ping_id, else: match.pong_id)
    })
    |> Repo.update()

    {:reply, {:ok, %{type: "GAME_STARTED", payload: %{started: started}}}, socket}
  end

  # Handle the highscores
  def handle_in("highscores", _, socket) do
    highscores =
      Enum.map(Accounts.highscore(), fn {user, won} ->
        user
        |> Map.put(:won, won)
        |> Map.drop([:__meta__, :__struct__, :tag])
      end)

    {:reply, {:ok, %{type: "UPDATE_HIGHSCORES", payload: %{players: highscores}}}, socket}
  end

  # Handle the points for a match
  def handle_in("points", _, %Socket{topic: "match:game:" <> match_id} = socket) do
    match = Matches.get_match!(match_id)

    points =
      Enum.map(Matches.get_points_for_match(match_id), fn point ->
        %{
          time: point.inserted_at,
          player: if(match.ping_id == point.user_id, do: "ping", else: "pong"),
          player_id: point.user_id
        }
      end)

    {:reply, {:ok, %{type: "ALL_POINTS", payload: %{points: points}}}, socket}
  end
end
