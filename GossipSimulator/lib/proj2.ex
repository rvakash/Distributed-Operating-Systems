defmodule Proj2 do
  def main(args) do
    numNodes = String.to_integer(Enum.at(args,0))
    topology = Enum.at(args,1)
    algorithm = Enum.at(args,2)
    IO.puts "No of nodes is #{numNodes}"
    IO.puts "Topology name  is #{topology}"
    IO.puts "Algorithm name is #{algorithm}"
    IO.puts "Trail"
  end
end
