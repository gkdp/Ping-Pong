defmodule PingPong.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PingPong.Repo

  alias PingPong.Accounts.User
  alias PingPong.Matches.Match

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def highscore do
    query =
      from u in User,
        join: m in Match, on: u.id == m.won_by_id,
        group_by: u.id,
        limit: 5,
        select: {u, count(m.id)}

    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_tag(tag), do: Repo.get_by(User, tag: tag)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def set_rating(%User{} = user, attrs) do
    # TODO
    # user
    # |> User.changeset(attrs)
    # |> Repo.update()
  end

  def set_rating(id, rating) do
    query = from u in User,
      update: [set: [rating: ^rating]],
      where: u.id == ^id

    Repo.update_all(query, [])
  end

  def get_ratings(ping_id, pong_id) do
    query =
      from u in User,
        where: u.id in [^ping_id, ^pong_id],
        select: {u.id, u.rating},
        order_by: [
          fragment("id = ? DESC", ^ping_id),
          fragment("id = ? DESC", ^pong_id)
        ]

    Repo.all(query)
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
