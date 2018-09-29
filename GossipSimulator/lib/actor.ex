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
        IO.puts "handle_cast : nodeId - #{nodeId} recCount - #{recCount} rumour: #{rumour}"# gossipingTask - #{gossipingTask}"
        # IO.puts "#{is_list({2,3})}"
        # IO.inspect is_list('Hello')
        # IO.inspect is_list(elem(state, 1))
        nL = elem(state, 1)
        # IO.inspect head
        # IO.inspect(head)
        # Map.put(state, "recCount", recCount + 1)

        # IO.puts "1here #{rumour}"

        gossipingTask = 
            if gossipingTask == 0 and recCount == 1 do
                Task.start(fn -> startGossiping(nL, rumour) end) 
            end
        gossipingTask = 
            if recCount == 10 and gossipingTask != 0 do
                Task.shutdown(gossipingTask, :brutal_kill)
                0
            end
        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, gossipingTask}}
    end

    def startGossiping(nL, rumour) do
        # IO.puts "In startGossiping "
        #{Enum.random(nL)}"
        GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
        # Process.sleep(100)
        startGossiping(nL, rumour)
    end
end