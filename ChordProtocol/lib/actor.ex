defmodule Actor do
    use GenServer

    def init([nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m]) do

        {:ok, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:start_request, rumour}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m} = state
        keyId = generateRandomKey(numOfNodes, keys)
                
        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m}}
    end

    def handle_call(:is_active , _from, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes, numOfRequests, m}}
    end

    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

    def generateRandomKey(numOfNodes, keys) do
        keyNum = :rand.uniform(numOfNodes)
        keyWithOverFlowinHex = :crypto.hash(:sha, intToString(keyNum+100)) |> String.slice(0..m) |> Base.encode16
        {keyWithOverFlowinInt, x} = Integer.parse(keyWithOverFlowinHex, 16)
        keyId = rem(keyWithOverFlowinInt, :math.pow(2,m) |> round)
        # If the key it generated is present in the same node
        if(List.first(Enum.find(keysList, fn(elem) -> elem == keyId end)) != nil) do
            generateRandomKey(numOfNodes, keys)
        else
            keyId
        end
    end
end
