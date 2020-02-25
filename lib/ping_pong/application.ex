defmodule PingPong.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      PingPong.Repo,
      # Start the endpoint when the application starts
      PingPongWeb.Endpoint,

      worker(PingPongControls.Buttons, [17], id: :ping_button),
      worker(PingPongControls.Buttons, [27], id: :pong_button),

      # Starts a worker by calling: PingPong.Worker.start_link(arg)
      # {PingPong.Worker, arg},
      worker(PingPong.Notifications, ["matches_changes"], id: :matches_changes),
      worker(PingPong.Notifications, ["points_changes"], id: :points_changes)
    ]

    children =
      children
      |> add_child(Code.ensure_compiled?(Nerves.IO.RC522), fn -> [{Nerves.IO.RC522, {PingPongControls.Reader, :tag_scanned}}] end)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PingPong.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def add_child(children, condition, output) do
    if condition do
      children ++ output.()
    else
      children
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PingPongWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
