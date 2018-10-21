defmodule Actor do
    use GenServer

    def init([nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m]) do

        {:ok, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:start_request, rumour}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m} = state
        keyList = generateRandomKeys(numOfNodes, keys, numOfRequests)
        hopCount = 0
        Enum.each(keyList, fn(key) -> 
            # lookup(keyID, sourceID,hopCount,fingerTable)
            GenServer.cast(intToAtom(nodeId), {:message, key, nodeId, hopCount})
        end)
        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:message, key, sourceId, hopCount}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m} = state
        Lookup.lookup(key, nodeId, sourceId, successor, hopCount, fingerTable, keysList)

        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    end

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m} = state

        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    end

    def handle_call(:is_active , _from, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m} = state

        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    end

    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

    def generateRandomKey(numOfNodes, keys, numOfRequests) do
        keysList = for i <- 1..numOfRequests do
            keyNum = :rand.uniform(numOfNodes)
            keyWithOverFlowinHex = :crypto.hash(:sha, intToString(keyNum+100)) |> String.slice(0..m) |> Base.encode16
            {keyWithOverFlowinInt, x} = Integer.parse(keyWithOverFlowinHex, 16)
            keyId = rem(keyWithOverFlowinInt, :math.pow(2,m) |> round)
            # If the key it generated is present in the same node
            if(Enum.find(keysList, fn(elem) -> elem == keyId end) != nil) do
                generateRandomKey(numOfNodes, keys, numOfRequests)
            else
                keyId
            end
        end
    end

    def intToAtom(integer) do
        integer |> Integer.to_string() |> String.to_atom()
    end
end
