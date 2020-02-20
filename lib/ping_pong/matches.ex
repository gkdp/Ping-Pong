defmodule PingPong.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias PingPong.Repo

  alias PingPong.Matches.Match
  alias PingPong.Matches.Point

  alias PingPong.Championships.Rule

  alias PingPong.Accounts.User

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Gets the active match.
  """
  def get_active_match() do
    query =
      from m in Match,
        where: not is_nil(m.started) and is_nil(m.ended)

    Repo.one(query)
  end

  @doc """
  Gets the active match id.
  """
  def get_active_match_id() do
    query =
      from m in Match,
        where: not is_nil(m.started) and is_nil(m.ended),
        select: m.id

    Repo.one(query)
  end

  @doc """
  Gets the match with points.
  """
  def get_match_with_points(id) do
    query =
      from m in Match,
        full_join: ping in Point, on: ping.user_id == m.ping_id and ping.match_id == ^id,
        full_join: pong in Point, on: pong.user_id == m.pong_id and pong.match_id == ^id,
        where: m.id == ^id,
        distinct: true,
        select: {m, count(ping.id, :distinct), count(pong.id, :distinct)},
        preload: [:ping, :pong, :won_by, :rule, :serve_started_by],
        group_by: [m.id]

    Repo.one(query)
  end

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Creates a point.

  ## Examples

      iex> create_point(%{field: value})
      {:ok, %Point{}}

      iex> create_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_point(attrs \\ %{}) do
    %Point{}
    |> Point.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_point(%Point{} = point) do
    Repo.delete(point)
  end





  # Logic
  def inspect_match(id) do
    {match, ping_points, pong_points} = get_match_with_points(id)

    if match.ended == nil do
      %{ping_id: ping_id, pong_id: pong_id} = match

      [{^ping_id, ping_rating}, {^pong_id, pong_rating}] =
        from(
          u in User,
          where: u.id in [^ping_id, ^pong_id],
          select: {u.id, u.rating}
        )
        |> Repo.all()

      cond do
        ping_points >= match.rule.maximum ->
          match
          |> Match.changeset(%{won_by_id: match.ping_id, ended: DateTime.utc_now})
          |> Repo.update()

          {ping_rating_new, pong_rating_new} = Elo.rate(ping_rating, pong_rating, :win)

          up = from u in User,
            update: [set: [rating: ^ping_rating_new]],
            where: u.id == ^ping_id

          Repo.update_all(up, [])

          up = from u in User,
            update: [set: [rating: ^pong_rating_new]],
            where: u.id == ^pong_id

          Repo.update_all(up, [])

        pong_points >= match.rule.maximum ->
          match
          |> Match.changeset(%{won_by_id: match.pong_id, ended: DateTime.utc_now})
          |> Repo.update()

          {pong_rating_new, ping_rating_new} = Elo.rate(pong_rating, ping_rating, :win)

          up = from u in User,
            update: [set: [rating: ^ping_rating_new]],
            where: u.id == ^ping_id

          Repo.update_all(up, [])

          up = from u in User,
            update: [set: [rating: ^pong_rating_new]],
            where: u.id == ^pong_id

          Repo.update_all(up, [])

        true ->
          true
      end
    end

    {match, ping_points, pong_points}
  end

  def check_serving(%Match{rule: %Rule{serving: serving}, serve_started_by_id: id, ping_id: ping_id}, points) do
    case rem(floor(points / serving), 2) do
      0 ->
        if id == ping_id, do: "ping", else: "pong"

      1 ->
        if id == ping_id, do: "pong", else: "ping"
    end
  end
end
