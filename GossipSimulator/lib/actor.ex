defmodule Actor do
    use GenServer
    require Logger

    def init([nodeId, neighborList, algorithm, parentPID]) do
        # state = Map.put(state, "neighborList", neighborList)
        # IO.puts "In init of actor - #{nodeId}"
        inspect "#{nodeId}"
        recCount = 1
        gossipingTask = 0
        isActive = 1
        nodesDead = 0
# s and w required only for pushsum
        olds1 = nodeId
        oldw1 = 1
        olds2 = -1
        oldw2 = -1
        {:ok, {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID, olds1, oldw1, olds2, oldw2}}#nodeId, neighborList, algorithm, receivedCount, s, w
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID, olds1, oldw1, olds2, oldw2} = state
        # IO.puts "handle_cast : nodeId - #{nodeId} recCount - #{recCount} rumour: #{rumour}"# gossipingTask - #{gossipingTask}"
        # IO.puts "#{is_list({2,3})}"
        # IO.inspect is_list('Hello')
        # IO.inspect is_list(elem(state, 1))
        nL = elem(state, 1)
        # IO.inspect head
        # IO.inspect(head)
        # Map.put(state, "recCount", recCount + 1)

        # IO.puts "1here #{rumour}"
        # if rem(recCount, 15) == 0 do
        #     IO.inspect nL, label: "nodeId = #{nodeId} Neighbor List = "
        # end
#         IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} recCount = #{recCount}"

        {:ok, gossipingTask} = #Task.start(fn -> startGossiping(nL, rumour) end)
            if recCount == 1 do
                # IO.puts "Nodeid = #{nodeId} started gossiping!"
                Task.start(fn -> startGossiping(nL, rumour, nodeId, 0, 0) end)#nL, rumour, nodeId, prevNum, count
                # spawn(Gossip, :startGossiping, [nodeId, nL, rumour])
            else
                {:ok, gossipingTask}
            end
        # IO.inspect gossipingTask, label: "before gossipingTask = "
        if rem(recCount, 10) == 0 do
            # IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} recCount = #{recCount}"
        end
        # inspect(nodeId)
        # inspect(recCount)
        isActive =
        if recCount > 9 do
            # IO.inspect(gossipingTask)
            # Task.shutdown(gossipingTask,:brutal_kill)
            # IO.puts "Shutting down nodeId = #{nodeId}"
            Process.exit(gossipingTask, :brutal_kill)
            if Process.alive?gossipingTask do
                # IO.puts "ALIVE"
            else
                # IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD nodeId = #{nodeId}"
                if recCount < 11 do
                    # IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD nodeId = #{nodeId}"
                    send parentPID, 0
                else
                    # IO.puts "DEAD. Already told parent I am dead. nodeId = #{nodeId}"
                end
            end
            0
            # send gossipingTask, {}
            # terminate(:shutdown, state)
            # Process.exit(gossipingTask, :kill)
            # GenServer.stop(Proj2.intToAtom(nodeId), :normal)
        else
            1
        end

        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, gossipingTask, isActive, parentPID, olds1, oldw1, olds2, oldw2}}
    end

    #########################################################################################3
    ##########################################################################################33
    #######################################################################################333
    #PUSHSUM STARTS HERE

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID, olds1, oldw1, olds2, oldw2 } = state

        nL = elem(state, 1)
        IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} recCount = #{recCount}"
        updateds = olds1 + news
        updatedw = oldw1 + neww
        saves = updateds/2
        savew = updatedw/2
        if rem(recCount, 10) == 0 do
            # IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} recCount = #{recCount}"
        end
        isActivegossipingTask =
        if(isActive == 1 and abs(updateds/updatedw - olds1/oldw1) < :math.pow(10, -10) and abs(olds1/oldw1 - olds2/oldw2) < :math.pow(10, -10)) do
            # IO.inspect(gossipingTask)
            # Task.shutdown(gossipingTask,:brutal_kill)
            # IO.puts "Shutting down nodeId = #{nodeId}"
            Process.exit(gossipingTask, :brutal_kill)
            if Process.alive?gossipingTask do
                IO.puts "ALIVE"
            else
                # IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD nodeId = #{nodeId}"
                # if recCount < 11 do
                #     # IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD nodeId = #{nodeId}"
                # else
                #     # IO.puts "DEAD. Already told parent I am dead. nodeId = #{nodeId}"
                # end
            end
            send parentPID, 0
            IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD. nodeId = #{nodeId}"
            # send(self, :kill_me_pls)
            {0, gossipingTask}
        else
            gossipingTask =
            if recCount == 1 do
                {:ok, gossipingTask} = Task.start(fn -> startGossipingPushSum(nL, saves, savew, nodeId, 0, 0) end)#nL, rumour, nodeId, prevNum, count
                # IO.inspect gossipingTask, label: "here"
                gossipingTask
            else
                # if Process.alive?gossipingTask do
                #     # IO.puts "ALIVE"
                # else
                #     # IO.puts "Task Dead nodeId = #{nodeId}"
                # end
                Process.exit(gossipingTask, :kill)
                {:ok, gossipingTask} = Task.start(fn -> startGossipingPushSum(nL, saves, savew, nodeId, 0, 0) end)#nL, rumour, nodeId, prevNum, count
                gossipingTask
            end
            # IO.inspect gossipingTask, label: "here1"
            {1, gossipingTask}
        end
        # IO.inspect elem(isActivegossipingTask, 1), label: "nodeId = #{nodeId}  gossipingTask = #{gossipingTask}"
        # IO.inspect elem(isActivegossipingTask, 0), label: "nodeId = #{nodeId}  isActive = #{isActive}"
        # IO.inspect gossipingTask, label: "here2"
        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, elem(isActivegossipingTask, 1), elem(isActivegossipingTask, 0), parentPID, saves, savew, olds1, oldw1}}
    end

    def startGossipingPushSum(nL, sends, sendw, nodeId, prevNum, count) do
        IO.puts "in startGossiping. nodeId= #{nodeId} nL = #{nL} "

        if nL != [] do
            x = Enum.random(nL)
            newX =
            if x == prevNum do
# sleep is required so that the erlangVM gets to schedule another process. Otherwise it may choose the same neighbor
#and bombard it multiple times without giving the neighbor a chance to execute. This will cause a problem in line if not handled.
                Process.sleep(3)
                Enum.random(nL)
            else
                x
            end
            neighborId = Proj2.intToAtom(newX)
            case GenServer.call(neighborId, :is_active) do
                1 ->
                    # IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} and I am choosing neighbor = #{newX}"
                    # IO.puts "I am still transmitting!!. nodeId = #{nodeId}"
                    GenServer.cast(neighborId, {:message_pushsum, sends, sendw})
                    #   ina_xy -> GenServer.cast(Master,{:droid_inactive, ina_xy})
                    startGossipingPushSum(nL,  sends, sendw, nodeId, newX, count)

                0 ->
                    # Remove the Dead nodes from neighbor list
                    nL1 = nL -- [newX]
                    # If your neighbor list is empty add yourself to the neighborlist to gossip yourself
                    if nL1 == [] do
                        nL2 = nL1 ++ [nodeId]
                        startGossipingPushSum(nL2, sends, sendw, nodeId, newX, count)
                    else
                    # IO.inspect nL1, label: "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH  ="
                        startGossipingPushSum(nL1, sends, sendw, nodeId, newX, count)
                    end
            end
            # startGossiping(nL, rumour, nodeId, count)
        end

        #Can improve convergence better if I make sure that 80% of the nodes are dead
        #and I can remove them from my neighbor list without adding too much overhead by removing everytime
        #can still make it better if only 1 node does this and remaining all are still cast all
        # GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
        # # Process.sleep(10)
        # startGossiping(nL, rumour, nodeId, prevNum, count)
    end

    def handle_call(:is_active , _from, state) do
        # IO.inspect _from, label: "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
        {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID, olds1, oldw1, olds2, oldw2} = state
        {:reply, isActive, state}
    end

    def startGossiping(nL, rumour, nodeId, prevNum, count) do
        # IO.puts "nodeId= #{nodeId} In startGossiping "
        #{Enum.random(nL)}"
        # if rem(count, 15) == 0 do
        #     IO.inspect nL, label: "nodeId = #{nodeId} Neighbor List = "
        # end
        # IO.inspect nL, label: "nodeId = #{nodeId} nL ="
        if nL != [] do
            x = Enum.random(nL)
            newX =
            if x == prevNum do
# sleep is required so that the erlangVM gets to schedule another process. Otherwise it may choose the same neighbor
#and bombard it multiple times without giving the neighbor a chance to execute. This will cause a problem in line if not handled.
                Process.sleep(3)
                Enum.random(nL)
            else
                x
            end
            neighborId = Proj2.intToAtom(newX)
            case GenServer.call(neighborId, :is_active) do
                1 ->
                    # IO.puts "I AM ACTIVE!!! nodeId = #{nodeId} and I am choosing neighbor = #{newX}"
                    # IO.puts "I am still transmitting!!. nodeId = #{nodeId}"
                    GenServer.cast(neighborId, {:message, rumour})
                    #   ina_xy -> GenServer.cast(Master,{:droid_inactive, ina_xy})
                    startGossiping(nL, rumour, nodeId, newX, count)

                0 ->
                    # Remove the Dead nodes from neighbor list
                    nL1 = nL -- [newX]
                    # If your neighbor list is empty add yourself to the neighborlist to gossip yourself
                    if nL1 == [] do
                        Process.sleep(1)
                        nL2 = nL1 ++ [nodeId]
                        startGossiping(nL2, rumour, nodeId, newX, count)
                    else
                    # IO.inspect nL1, label: "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH  ="
                        startGossiping(nL1, rumour, nodeId, newX, count)
                    end
            end
            # startGossiping(nL, rumour, nodeId, count)
        end

        #Can improve convergence better if I make sure that 80% of the nodes are dead
        #and I can remove them from my neighbor list without adding too much overhead by removing everytime
        #can still make it better if only 1 node does this and remaining all are still cast all
        # GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
        # # Process.sleep(10)
        # startGossiping(nL, rumour, nodeId, prevNum, count)
    end



    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

end
