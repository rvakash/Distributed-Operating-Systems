#####################################################
# Course: COP 5615, Distributed Operating System Principles, University of Florida
# Autors: Akash R Vasishta, Aditya Bhanje
# Description: Use Actor Model(Genserver) in Elixir to
#####################################################
defmodule Proj2 do
# Instructions to run the project
# 1) $mix compile
# 2) $mix run -e Proj2.main 100 full gossip

    def main do
        # Receive total number of nodes, topology, algorithm, triggerNodes(optional), threshold(optional) from user.
        # Read README.md for more details
        numOfNodes = String.to_integer(Enum.at(System.argv, 0))
        topology = Enum.at(System.argv, 1)
        algorithm = Enum.at(System.argv, 2)
        IO.inspect numOfNodes
        IO.inspect topology
        IO.inspect algorithm
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
        #used this numOfNodes1 everywhere for now
        numOfNodes1=
        if topology=="Torus" do
          trunc(:math.pow(:math.ceil(:math.sqrt(numOfNodes)), 2))
        else
          numOfNodes
        end
        # numOfNodes = if String.contains?(topology, "2d"), do: round(:math.pow(round(:math.sqrt(numOfNodes)), 2)), else: numOfNodes

        case topology do
            "full"          ->
                Enum.each 1..numOfNodes1, fn nodeId ->
                    neighborList = GetNeighbor.full(nodeId, numOfNodes1)
                    inspect neighborList
                    nodeId_atom = intToAtom(nodeId)
                    GenServer.start_link(Actor, [nodeId, neighborList, algorithm, self], name: nodeId_atom)
                    # IO.puts "In main, nodeId = #{nodeId}"
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
            "Torus"       ->
                Enum.each 1..numOfNodes1, fn nodeId ->
                    # generate3DTorus(numOfNodes);

                    neighborList = GetNeighbor.torus(nodeId, numOfNodes1)
                    inspect neighborList
                    nodeId_atom = intToAtom(nodeId)
                    GenServer.start_link(Actor, [nodeId, neighborList, algorithm,self], name: nodeId_atom)
                end
            "line"          ->
                Enum.each 1..numOfNodes1, fn nodeId ->
                    neighborList = GetNeighbor.perfectLine(nodeId, numOfNodes1)
                    inspect neighborList
                    nodeId_atom = intToAtom(nodeId)
                    GenServer.start_link(Actor, [nodeId, neighborList, algorithm, self], name: nodeId_atom)
                end
            # "imperfectLine" ->
            #     Enum.each 1..numOfNodes, fn nodeId ->
            #         neighborList = getNeighborsImperfectLine(nodeId, numOfNodes)
            #         GenServer.start_link(Actor, [nodeId, neighborList, algorithm], name: nodeId)
            #     end
        end
        start_time = System.system_time(:millisecond)
        GenServer.cast(intToAtom(2), {:message, "This is Elixir Gossip Simulator"})
        exitWorkers(numOfNodes1)
        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"
        # Process.sleep(100000)
    end

    def exitWorkers(0), do: nil

    def exitWorkers(numOfWorkers) do
        receive do
            exitValue -> inspect(exitValue)
            exitWorkers(numOfWorkers - 1)
        end
    end

    # def getNeighborsFull(nodeId,numOfNodes) do
    #     range = 1..numOfNodes
    #     range
    #     |> Enum.filter(fn(value) -> value != nodeId end)
    #     |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
    #     # IO.inspect Neighboringlist
    # end

    def intToAtom(integer) do
        integer |> Integer.to_string() |> String.to_atom()
    end
end



