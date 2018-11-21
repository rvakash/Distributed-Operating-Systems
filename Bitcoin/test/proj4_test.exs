defmodule Proj4Test do
  use ExUnit.Case
  doctest Proj4

  test "Bitcoin mining" do
    Proj4.mineBitcoins(self(), 3)
    assert_receive {:bitCoin, bitCoin}, 20000
    IO.puts "#{bitCoin}"
  end
end
