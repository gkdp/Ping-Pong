defmodule PingPongControls.Reader do
  import Ecto.Query, warn: false
  alias PingPong.Repo

  alias PingPong.Matches
  alias PingPong.Matches.Match
  alias PingPong.Accounts
  alias PingPong.Accounts.User

  def tag_scanned(tag) do
    with %User{id: id} <- Accounts.get_user_by_tag(tag) do
      case Matches.get_not_active_match() do
        %Match{ping_id: nil} = match ->
          match
          |> Match.changeset(%{ping_id: id})
          |> Repo.update()

        %Match{pong_id: nil, ping_id: ping_id} = match when ping_id != id ->
          match
          |> Match.changeset(%{pong_id: id})
          |> Repo.update()

        _ ->
          nil
      end
    end
  end
end
