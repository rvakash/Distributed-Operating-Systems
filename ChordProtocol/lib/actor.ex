defmodule Actor do
    use GenServer

    def init([nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes]) do

        {:ok, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes}}
    end

    def handle_cast({:message, rumour}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes}}
    end

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes}}
    end

    def handle_cast({:message_pushsum, news, neww}, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes}}
    end

    def handle_call(:is_active , _from, state) do
        {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes} = state

        {:noreply, {nodeId, keys, fingerTable, successor, prevNodeId, numOfNodes}}
    end

    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

end
