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
        m = 31

        # Network initialization or the Chord ring is formed here
        # Apply hash function, convert the hash to m bits and
        # then do a modulo 2^m to wrap around the ring
        # Converting to m bits just so the identifier space is not too huge and
        # the finger table is not too long. length(FT) = m
        nodesList = for nodeNum <- 1..numOfNodes do
            nodeWithOverFlowinHex = :crypto.hash(:sha, intToString(nodeNum)) |> String.slice(0..m) |> Base.encode16
            {nodeWithOverFlowinInt, x} = Integer.parse(nodeWithOverFlowinHex, 16)
            nodeId = rem(nodeWithOverFlowinInt, :math.pow(2,m) |> round)
            nodeId
        end
        keysList = for nodeNum <- 1..numOfNodes do
            keyWithOverFlowinHex = :crypto.hash(:sha, intToString(nodeNum+100)) |> String.slice(0..m) |> Base.encode16
            {keyWithOverFlowinInt, x} = Integer.parse(keyWithOverFlowinHex, 16)
            keyId = rem(keyWithOverFlowinInt, :math.pow(2,m) |> round)
            keyId
        end

        nodesListSorted = :lists.sort(nodesList)
        range=0..numOfNodes-1
        for i <- range do
            # getKeys between the node and its previous node.
            # keys = CodeSnippets.getKeys(previousId, nodeId, keysList)
            # Sometimes when the program gets complex and its 5am in an all nighter you tend to write programs like below
            # iex> List.pop_at([1, 2, 3], 0)
            # {1, [2, 3]}
            nodeId = elem(List.pop_at(nodesListSorted, i), 0)
            prevNodeId = elem(List.pop_at(nodesListSorted, i-1), 0)
            keys = CodeSnippets.getKeys(prevNodeId, nodeId, keysList)
        #   IO.inspect keys
            fingerTable = CodeSnippets.getFingerTable(nodeId, nodesListSorted,numOfNodes, m)
        end
    end

    def intToString(integer) do
        integer |> Integer.to_string()
    end
end
