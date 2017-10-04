defmodule SunPower do
  def get_power(time) do
    1
  end
  def hour_sun_power(h) do
    p = 0
    cond do
      h>=12 && h<=15 ->
        p = 1
      h<12 && h > 6 ->
        p = (h-6)/(12-6)
      h<20 && h>15 ->
        p = 1 - (h-15)/(20-15)
    end
    p
  end
  def hour_consume(h) do
    c = 0.2
    cond do
      h>=6 && h<=9 ->
        c = 1
      h>=17 && h<=23 ->
        c = 1
    end
    c
  end
end
