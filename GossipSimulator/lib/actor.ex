defmodule Actor do    
    use GenServer

    def init([nodeId, neighborList, algorithm]) do
        # Map.put(state, "neighborList", neighborList)
        {:ok, [Active,nodeId, neighborList, algorithm, 0]}#nodeId, neighborList, algorithm, receivedCount
    end

    def handle_cast({:message, rumour}, state) do
        {:ok, count} = Map.fetch(state, "count")
        state = Map.put(state, "count", count + 1)

    end
end