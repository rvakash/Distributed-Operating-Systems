defmodule Taskstart do
    def main do
#        numOfNodes = String.to_integer(Enum.at(args, 0))
#        topology = Enum.at(args, 1)
#        algorithm = Enum.at(args, 2)
	numOfNodes  = 2
	topology = "full"
	algorithm = "gossip"        
	Enum.each 1..numOfNodes, fn nodeId ->
            neighborList = getNeighborsFull(nodeId, numOfNodes)
            inspect neighborList
            nodeId_atom = intToAtom(nodeId)
            GenServer.start(Actor, [nodeId, neighborList, algorithm], name: nodeId_atom)
        end
        GenServer.cast(intToAtom(2), {:message, "This is Elixir Gossip Simulator"})

    end
    def getNeighborsFull(nodeId,numOfNodes) do
        range = 1..numOfNodes
        range
        |> Enum.filter(fn(value) -> value != nodeId end)
        |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
        # IO.inspect Neighboringlist
    end
    
    def intToAtom(integer) do
        integer |> Integer.to_string() |> String.to_atom()
    end

end
