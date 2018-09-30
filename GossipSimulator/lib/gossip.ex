defmodule Gossip do
    # use GenServer
    def startGossiping(nodeId, nL, rumour) do
        # IO.inspect(nL)
        randomN = Enum.random(nL)
        neighborId = Proj2.intToAtom(randomN)
        IO.puts "Gossiping nodeId = #{nodeId}, neighborId = #{neighborId} "
        IO.inspect nL, label: "nodeId = #{nodeId} Neighbor List = "
        case GenServer.call(neighborId, :is_active) do
            1 -> GenServer.cast(neighborId, {:message, rumour})
                #   ina_xy -> GenServer.cast(Master,{:droid_inactive, ina_xy})
                # Process.sleep(100)
                startGossiping(nodeId, nL, rumour)

            0 ->
                IO.inspect nL, label: "nodeId = #{nodeId} nL before = "
                nL1 = nL -- [randomN]
                IO.inspect nL1, label: "nodeId = #{nodeId} nL1 after = "
                if nodeId != randomN do
                    IO.inspect nL1, label: "nodeId = #{nodeId} neighborId= #{neighborId} is dead. Neighbor List = "
                    IO.puts "#{nL}"
                    nL2 = 
                        if nL1 == [] do
                            IO.puts "nodeId = #{nodeId} neighborId= #{neighborId} is dead. 003hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
                            nL1 ++ [nodeId]
                        else
                            nL1
                        end
                    startGossiping(nodeId, nL2, rumour)                        
                end
        end        
        IO.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!EXITING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1 nodeId = #{nodeId}"
        # exit(:boom)
    end

end