defmodule PingPongControls.Buttons do
  use GenServer

  alias PingPong.Matches
  alias PingPong.Matches.Match

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin)
  end

  def init(pin) do
    {:ok, pid} =
      Circuits.GPIO.open(pin, :input, pull_mode: :pullup)

    Circuits.GPIO.set_interrupts(pid, :rising)

    {:ok, {nil, pid}}
  end

  def handle_info({:circuits_gpio, pin, time, 1}, {last_time, pid}) do
    with {:ok, datetime} <- DateTime.from_unix(time, :nanosecond),
         %Match{id: id, ping_id: ping_id, pong_id: pong_id} <- Matches.get_active_match() do
      if last_time == nil or DateTime.diff(datetime, last_time) >= 2 do
        Matches.create_point(%{
          match_id: id,
          user_id: if(pin == 10, do: ping_id, else: pong_id)
        })
      end

      {:noreply, {datetime, pid}}
    else
      _ ->
        {:noreply, {last_time, pid}}
    end
  end
end
