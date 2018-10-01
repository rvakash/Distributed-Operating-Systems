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
        {:ok, {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID}}#nodeId, neighborList, algorithm, receivedCount
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID} = state
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

        {:ok, gossipingTask} = #Task.start(fn -> startGossiping(nL, rumour) end)
            if recCount == 1 do
                Task.start(fn -> startGossiping(nL, rumour, nodeId, 0) end)
                # spawn(Gossip, :startGossiping, [nodeId, nL, rumour])
            else
                {:ok, gossipingTask}
            end
        # IO.inspect gossipingTask, label: "before gossipingTask = "
        isActive =
        if recCount > 9 do
            # IO.inspect(gossipingTask)
            # Task.shutdown(gossipingTask,:brutal_kill)
            # IO.puts "Shutting down nodeId = #{nodeId}"
            Process.exit(gossipingTask, :kill)
            if Process.alive?gossipingTask do
                IO.puts "ALIVE"
            else
                # IO.puts "DEADDEADDEADDEADDEADDEADDEADDEADDEADDEADDEAD"
                send parentPID, 0
            end
            0
            # send gossipingTask, {}
            # terminate(:shutdown, state)
            # Process.exit(gossipingTask, :kill)
            # GenServer.stop(Proj2.intToAtom(nodeId), :normal)
        else
            1
        end

        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, gossipingTask, isActive, parentPID}}
    end

    def handle_call(:is_active , _from, state) do
        # IO.inspect _from, label: "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
        {nodeId, neighborList, algorithm, recCount, gossipingTask, isActive, parentPID} = state
        {:reply, isActive, state}
    end

    def startGossiping(nL, rumour, nodeId, count) do
        # IO.puts "In startGossiping "
        #{Enum.random(nL)}"
        # if rem(count, 15) == 0 do
        #     IO.inspect nL, label: "nodeId = #{nodeId} Neighbor List = "
        # end
        # IO.inspect nL
        # x = Enum.random(nL)
        # neighborId = Proj2.intToAtom(x)
        # case GenServer.call(neighborId, :is_active) do
        #     1 ->
        #         GenServer.cast(neighborId, {:message, rumour})
        #         #   ina_xy -> GenServer.cast(Master,{:droid_inactive, ina_xy})
        #         # Process.sleep(100)
        #         startGossiping(nL, rumour, nodeId, count)

        #     0 ->
        #         nL1 = nL -- [x]
        #         # IO.inspect nL1, label: "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH  ="
        #         startGossiping(nL1, rumour, nodeId, count)
        # end

        GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
        # Process.sleep(10)
        startGossiping(nL, rumour, nodeId, count)
    end
end
