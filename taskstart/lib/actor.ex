defmodule Actor do    
    use GenServer
    require Logger

    def init([nodeId, neighborList, algorithm]) do
        IO.inspect "#{nodeId}"
        recCount = 1
        gossipingTask = 0
        {:ok, {nodeId, neighborList, algorithm, recCount, gossipingTask}}#nodeId, neighborList, algorithm, receivedCount
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, neighborList, algorithm, recCount, gossipingTask} = state
        IO.puts "nodeId - #{nodeId} recCount - #{recCount} handle_cast: #{rumour} gossipingTask - #{gossipingTask}"
        nL = elem(state, 1)
        IO.inspect nL
        gossipingTask = Task.start(fn -> startGossiping end) 
        IO.puts "Now again - #{rumour}"
        {:noreply, {nodeId, neighborList, algorithm, recCount + 1, gossipingTask}}
    end

    def startGossiping do
        IO.puts "In startGossiping "
        #{Enum.random(nL)}"
        # GenServer.cast(Proj2.intToAtom(Enum.random(nL)), {:message, rumour})
    end
end