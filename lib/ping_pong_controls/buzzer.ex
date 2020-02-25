defmodule PingPongControls.Buzzer do
  def buzz() do
    {:ok, gpio} = Circuits.GPIO.open(18, :output)

    Circuits.GPIO.write(gpio, 1)

    Circuits.GPIO.close(gpio)
  end
end
