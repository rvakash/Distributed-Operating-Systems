defmodule Actor do
    use GenServer

    def init([nodeId, neighborList, algorithm, parentPID]) do

    end

    def handle_cast({:message, rumour}, state) do

    end

    def handle_cast({:message_pushsum, news, neww}, state) do

    end

    def handle_call(:is_active , _from, state) do

    end

    def handle_info(:kill_me_pls, state) do
        {:stop, :normal, state}
    end

    def terminate(_, state) do
        IO.inspect "Look! I'm dead."
    end

end
