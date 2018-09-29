defmodule Actor do    
    use GenServer

    def init([nodeId, neighborList, algorithm]) do
        # state = Map.put(state, "neighborList", neighborList)
        # IO.puts "In init of actor - #{nodeId}"
        inspect "#{nodeId}"
        recCount = 1
        gossipingTask = 0
        {:ok, {nodeId, neighborList, algorithm, recCount, gossipingTask}}#nodeId, neighborList, algorithm, receivedCount
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, neighborList, algorithm, recCount, gossipingTask} = state
        IO.puts "nodeId - #{nodeId} recCount - #{recCount} handle_cast: #{rumour} gossipingTask - #{gossipingTask}"
        # IO.puts "#{is_list({2,3})}"
        # IO.inspect is_list('Hello')
        # IO.inspect is_list(elem(state, 1))
        nL = elem(state, 1)
        # IO.inspect head
        # IO.inspect(head)
        # Map.put(state, "recCount", recCount + 1)

        IO.puts "1here #{rumour}"

        gossipingTask = Task.start(fn -> startGossiping(nL, rumour) end) 
        IO.puts "Now again - #{rumour}"
            # if gossipingTask == 0 do
            #     IO.puts "here"
            #     Task.start fn -> startGossiping(nL, "#{rumour}") end
            # else
            #     1
            # end
        # gossipingTask = 
            # if recCount > 9 do
            #     Task.shutdown(gossipingTask, :brutal_kill)
            #     # 1
            # # else
            # #     1
            # end
        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, gossipingTask}}
    end

    def startGossiping(nL, rumour) do
        IO.puts "In startGossiping "
        #{Enum.random(nL)}"
        # GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
    end
end