defmodule Actor do    
    use GenServer

    def init([nodeId, neighborList, algorithm]) do
        # state = Map.put(state, "neighborList", neighborList)
        # IO.puts "In init of actor - #{nodeId}"
        inspect "#{nodeId}"
        recCount = 1
        {:ok, {nodeId, neighborList, algorithm, recCount}}#nodeId, neighborList, algorithm, receivedCount
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, neighborList, algorithm, recCount} = state
        # IO.puts "nodeId - #{nodeId} recCount - #{recCount} handle_cast: #{rumour}"
        # [head | tail] = elem(state, 2)
        # IO.inspect(head)
        # Map.put(state, "recCount", recCount + 1)
        # IO.puts "here #{rumour}"
        if recCount < 9 do
            
        end
        {:noreply, {nodeId, neighborList, algorithm, recCount + 1}}
    end
end