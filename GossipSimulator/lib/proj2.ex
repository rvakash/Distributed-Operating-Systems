#####################################################
# Course: COP 5615, Distributed Operating System Principles, University of Florida
# Autors: Akash R Vasishta, Aditya Bhanje 
# Description: Use Actor Model(Genserver) in Elixir to 
#####################################################
defmodule Proj2 do
# Instructions to run the project
# 1) $mix escript.build
# 2) $escript proj2 100 full gossip

    def main(args) do
        # Receive total number of nodes, topology, algorithm, triggerNodes(optional), threshold(optional) from user.
        # Read README.md for more details
        numOfNodes = String.to_integer(Enum.at(args,0))
        topology = Enum.at(args,1)
        algorithm = Enum.at(args,2)
        # triggerNodes = 
        #     if Enum.at(args, 3) != nil do
        #         String.to_integer(Enum.at(args, 3))
        #     else
        #         1
        #     end
        # threshold = 
        #     if Enum.at(args, 4) != nil do
        #         String.to_integer(Enum.at(args, 4))
        #     else
        #         0
        #     end
        numOfNodes = if String.contains?(topology, "2d"), do: round(:math.pow(round(:math.sqrt(numOfNodes)), 2)), else: numOfNodes

        case topology do
            "full"          ->
                Enum.each 1..numOfNodes, fn nodeId ->
                    neighborList = getNeighborsFull(nodeId, numOfNodes)
                    GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
                end
            # "3DGrid"        ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         neighborList = getNeighbors3DGrid(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
            # "2DGrid"        ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         neighborList = getNeighbors2DGrid(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
            # "3DTorus"       ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         # generate3DTorus(numOfNodes);
            #         neighborList = getNeighbors3DTorus(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
            # "line"          ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         neighborList = getNeighborsLine(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
            # "imperfectLine" ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         neighborList = getNeighborsImperfectLine(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
        end

        GenServer.cast(1, {:message, "This is Elixir Gossip Simulator"})
    end

    def getNeighborsFull(nodeId,numOfNodes) do
        range = 1..numOfNodes
        range
        |> Enum.filter(fn(value) -> value != nodeId end)
        |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
        # IO.inspect Neighboringlist
      end
    
end



