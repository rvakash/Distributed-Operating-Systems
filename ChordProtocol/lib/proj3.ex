#####################################################
# Course: COP 5615, Distributed Operating System Principles, University of Florida
# Autors: Akash R Vasishta, Aditya Bhanje
# Description: Use Actor Model(Genserver) in Elixir to
## Instructions to run the project
# 1) $mix compile
# 2) $mix run -e Proj3.main 1000 10
#####################################################
defmodule Proj3 do
    def main do
        numOfNodes = String.to_integer(Enum.at(System.argv, 0))
        numOfRequests = String.to_integer(Enum.at(System.argv, 1))
        IO.inspect numOfNodes, label: "numOfNodes = "
        IO.inspect numOfRequests, label: "numOfRequests = "

        # Network initialization or the Chord ring is formed here
        Enum.each 1..numOfNodes, fn nodeNum ->
            nodeWithOverFlowinHex = :crypto.hash(:sha, intToString(nodeNum)) |> String.slice(0..31) |> Base.encode16
            {nodeWithOverFlowinInt, x} = Integer.parse(nodeWithOverFlowinHex, 16)
            nodeId = rem(nodeWithOverFlowinInt, :math.pow(2,31) |> round)
            # IO.inspect nodeId
            keyWithOverFlowinHex = :crypto.hash(:sha, intToString(nodeNum+100)) |> String.slice(0..31) |> Base.encode16
            {keyWithOverFlowinInt, x} = Integer.parse(keyWithOverFlowinHex, 16)
            keyId = rem(keyWithOverFlowinInt, :math.pow(2,31) |> round)

        end
    end
    def intToString(integer) do
        integer |> Integer.to_string()
    end
end
