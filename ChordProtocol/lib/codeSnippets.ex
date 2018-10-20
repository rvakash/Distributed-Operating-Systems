defmodule CodeSnippets do

    def getFingerTable(nodeId, nodesListSorted, m) do
        numOfNodes = length(nodesListSorted)
        range = 1..m
        fingerTable=for i <- range do
            p2powi_minus1=nodeId + round(:math.pow(2,i-1))
            row = for x <- 0..numOfNodes-1 do
                if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, -1), 0)) do
                    elem(List.pop_at(nodesListSorted, 0), 0)
                else
                    if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 <= elem(List.pop_at(nodesListSorted, x), 0 ) ) do
                        elem(List.pop_at(nodesListSorted, x), 0)
                    end
                end
            end
            rowafter_removenil =Enum.find(row, fn(elem) -> elem != nil end)
        end
    end

    def getKeys(prev,curr,keysList) do
        Enum.filter(keysList, fn(x) -> x > prev and x <= curr end)
    end
end
