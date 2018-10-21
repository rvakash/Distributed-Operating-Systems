defmodule Lookup do
    def lookup(keyID, nodeId, sourceID, successor, hopCount, fingerTable, keysList) do
        if(Enum.find(keysList, fn(elem) -> elem == keyID end) != nil) do
        # This node has the key
            {1, hopCount}
        else
            successorID = find_successor(keyID, nodeId, successor, fingerTable)
            #2nd cast to successor Node with hopCount++    
            {0, successorID}
        end

    end

    def find_successor(keyID, nodeId, successor, fingerTable) do
        if(nodeId<keyID and keyID<successor) do
            successor
        else
            nextID = closest_preceding_node(keyID, nodeId, fingerTable, length(fingerTable)-1)
            # nextID.find_successor(keyID) #################Genserver call to the nextID ka lookup
            nextID
        end
    end

    def closest_preceding_node(_, nodeId, _, 0) do
        nodeId
    end

    def closest_preceding_node(keyID, nodeId, fingerTable, lenOfFingerTable) do
        i = lenOfFingerTable
        nodeID = if elem(List.pop_at(fingerTable, i), 0) <= keyID do
                elem(List.pop_at(fingerTable, i), 0)
            else
                nil
            end
        if nodeID != nil do
            nodeID
        else
            closest_preceding_node(keyID, nodeId, fingerTable, lenOfFingerTable-1)
        end
    end

    # def closest_preceding_node(keyID, nodeID, fingerTable) do
    #     nodeID = for i <- (length(fingerTable)-1)..0 do
    #         if elem(List.pop_at(fingerTable, i), 0) <= keyID do
    #             elem(List.pop_at(fingerTable, i), 0)
    #         end
    #     end
    #     IO.inspect nodeID, label: "closest_preceding_node = "
    #     nodeIdfinal = List.to_integer(Enum.filter(nodeID, fn(elem) -> elem != nil end))
    #     IO.puts "here1"
    #     nodeIdfinal
    # end

    def intToAtom(integer) do
        integer |> Integer.to_string() |> String.to_atom()
    end

end