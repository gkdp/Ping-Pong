defmodule PingPongControls.Buttons do
  use GenServer

  alias PingPong.Matches
  alias PingPong.Matches.Match
  alias PingPong.Repo

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin)
  end

  def init(pin) do
    {:ok, pid} = Circuits.GPIO.open(pin, :input)

    Circuits.GPIO.set_interrupts(pid, :rising)

    {:ok, {nil, pid}}
  end

  def handle_info({:circuits_gpio, pin, time, 1}, {last_time, pid}) do
    with {:ok, datetime} <- DateTime.from_unix(time, :nanosecond),
         %Match{
           id: id,
           ping_id: ping_id,
           pong_id: pong_id,
           started: started,
           serve_started_by_id: started_id
         } = match <- Matches.get_active_match() do
      if started == nil and started_id == nil and (match.ping_id != nil and match.pong_id != nil) do
        started = NaiveDateTime.utc_now

        match
        |> Match.changeset(%{
          started: started,
          serve_started_by_id: if(pin == 17, do: match.ping_id, else: match.pong_id)
        })
        |> Repo.update()

        PingPongWeb.Endpoint.broadcast!("match:game:#{id}", "reduce", %{
          type: "GAME_STARTED",
          payload: %{
            started: started
          }
        })
      else
        if started != nil and (last_time == nil or DateTime.diff(datetime, last_time) >= 3) do
          Matches.create_point(%{
            match_id: id,
            user_id: if(pin == 17, do: ping_id, else: pong_id)
          })
        end
      end

      {:noreply, {datetime, pid}}
    else
      _ ->
        {:noreply, {last_time, pid}}
    end
  end
end
