defmodule CodeSnippets do
<<<<<<< HEAD

    def getFingerTable(nodeId, nodesListSorted) do
        range = 1..m
        fingerTable = for i <- range do
            successor(nodeId + :math.pow(2, i-1), nodesListSorted)
        end
    end

    def successor(id, nodesListSorted) do

    end
end
=======
  def getKeys(prev,curr,keysList) do
    Enum.filter(keysList, fn(x) -> x > prev and x <= curr end)
  end
end
>>>>>>> 77760ce5504fee24d1d973187436d9ea5b6f23a8
