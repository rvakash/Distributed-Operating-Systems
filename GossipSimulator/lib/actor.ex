defmodule Actor do    
    use GenServer

    def init([nodeId, neighborList, algorithm]) do
        {:ok, [Active,nodeId, neighborList, algorithm, 0]}#nodeId, neighborList, algorithm, receivedCount
    end

    
end