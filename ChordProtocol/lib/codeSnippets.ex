defmodule CodeSnippets do

    def getFingerTable(nodeId, nodesListSorted) do
        range = 1..m
        fingerTable = for i <- range do
            successor(nodeId + :math.pow(2, i-1), nodesListSorted)
        end
    end

    def successor(id, nodesListSorted) do
        # successor = Enum.each(nodesListSorted, )
    end
end
  def getKeys(prev,curr,keysList) do
    Enum.filter(keysList, fn(x) -> x > prev and x <= curr end)
  end
end
