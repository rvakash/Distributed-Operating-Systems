defmodule Actor do
    use GenServer

    def init([nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m]) do

        {:ok, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, 0}}
    end

    def handle_cast({:start_request}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, sum} = state
        keyList = generateRandomKeys(numOfNodes, keys, numOfRequests, m)
        hopCount = 0
        IO.puts "Starting requests"
        Enum.each(keyList, fn(key) -> 
            # lookup(keyID, sourceID,hopCount,fingerTable)
            GenServer.cast(intToAtom(nodeId), {:message, key, nodeId, hopCount})
        end)
        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, sum}}
    end

    def handle_cast({:message, key, sourceId, hopCount}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, sum} = state
        # if foundkey then result is sourceID else result is successorID
        IO.puts "node = #{nodeId} received message from source #{sourceId} with hopCount = #{hopCount}"
        {foundKey, result} = Lookup.lookup(key, nodeId, sourceId, successor, hopCount, fingerTable, keys)
        if foundKey == 1 do
            GenServer.cast(intToAtom(sourceId), {:foundKey, result, hopCount + 1})
        else
            GenServer.cast(intToAtom(result), {:message, key, nodeId, hopCount + 1})
        end
        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, sum}}
    end

    def handle_cast({:foundKey, destination, hopCount}, state) do
        {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m, prevSum} = state
        hopCountSum = prevSum + hopCount
        if numOfRequests == 1 do
            average = hopCountSum/numOfNodes
            IO.puts "Average inside the node = #{average}"
        end
        {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests-1, m, hopCountSum}}
    end

    # def handle_call(:is_active , _from, state) do
    #     {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m} = state

    #     {:noreply, {nodeId, keys, fingerTable, successor, predecessor, numOfNodes, numOfRequests, m}}
    # end

    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

    def generateRandomKeys(numOfNodes, keys, numOfRequests, m) do
        keysList = for i <- 1..numOfRequests do
            keyNum = :rand.uniform(numOfNodes)
            keyWithOverFlowinHex = :crypto.hash(:sha, intToString(keyNum+100)) |> String.slice(0..m) |> Base.encode16
            {keyWithOverFlowinInt, x} = Integer.parse(keyWithOverFlowinHex, 16)
            keyId = rem(keyWithOverFlowinInt, :math.pow(2,m) |> round)
            # If the key it generated is present in the same node
            if(Enum.find(keys, fn(elem) -> elem == keyId end) != nil) do
                generateRandomKeys(numOfNodes, keys, numOfRequests, m)
            else
                keyId
            end
        end
    end
    def intToString(integer) do
        integer |> Integer.to_string()
    end

    def intToAtom(integer) do
        integer |> Integer.to_string() |> String.to_atom()
    end
end
