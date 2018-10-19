defmodule CodeSnippets do

    def getFingerTable(nodeId, nodesListSorted) do
        range = 1..m
        fingerTable = for i <- range do
            successor(nodeId + :math.pow(2, i-1), nodesListSorted)
        end
    end

    def successor(id, nodesListSorted) do

    end
end