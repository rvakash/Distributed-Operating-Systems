defmodule Lookup do
    def lookup(keyID, nodeId, sourceID, successor, hopCount,fingerTable, keysList) do
        if(Enum.find(keysList, fn(elem) -> elem == keyID end) != nil) do
        #3rd cast to source Node
        end
        successorID=find_successor(keyID, nodeId, successor, fingerTable)
        #2nd cast to successor Node with hopCount++

    end

    def find_successor(keyID, nodeId, successor, fingerTable) do
        if(nodeId<keyID and keyID<successor) do
        successor
        else
        nextID=closest_preceding_node(keyID, nodeId, fingerTable)
        nextID.find_successor(keyID) #################Genserver call to the nextID ka lookup
        end
    end

    def closest_preceding_node(keyID, nodeID, fingerTable) do
        nodeID = for i <- (length(fingerTable)-1)..0 do
        if elem(List.pop_at(fingerTable, i), 0) <= keyID do
            elem(List.pop_at(fingerTable, i), 0)
        end
        end
        nodeIdfinal=List.to_integer(Enum.filter(nodeID, fn(elem) -> elem != nil end))
    end
end
