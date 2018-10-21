defmodule CodeSnippets do

    # def getFingerTable(nodeId, nodesListSorted, m) do
    #     numOfNodes = length(nodesListSorted)
    #     range = 1..m
    #     fingerTable(nodeId, nodesListSorted, m-1, numOfNodes-1, [])
    # end

    # def fingerTable(_, _, 0, _, fingerTableList) do
    #     fingerTableList
    # end

    # def fingerTable(nodeId, nodesListSorted, m, numOfNodes, fingerTableList) do
    #     p2powi_minus1_overflow = nodeId + round(:math.pow(2,m))
    #     p2powi_minus1 = rem(p2powi_minus1_overflow, :math.pow(2,m) |> round)
    #     {rowList, successor} = row(nodeId, nodesListSorted, m, p2powi_minus1, numOfNodes, [])
    #     rowafter_removenil = Enum.find(rowList, fn(elem) -> elem != nil end)
    #     fingerTable(nodeId, nodesListSorted, m-1, successor, fingerTableList ++ [rowafter_removenil])
    # end

    # def row(_, _, _, _, 0, rowList) do
    #     {rowList, -1}
    # end

    # def foundSuccessor(rowList, successor) do
    #     {rowList, successor}
    # end

    # def row(nodeId, nodesListSorted, m, p2powi_minus1, x, rowList) do
    #     {rowListElement, successor} = if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, -1), 0)) do
    #             IO.puts "inside if"
    #             {elem(List.pop_at(nodesListSorted, 0), 0), 0}
    #         else
    #             IO.puts "inside else p2powi_minus1 = #{p2powi_minus1}, x-1 = #{elem(List.pop_at(nodesListSorted, x-1), 0)}, x = #{elem(List.pop_at(nodesListSorted, x), 0 )} "
    #             if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 <= elem(List.pop_at(nodesListSorted, x), 0 ) ) do
    #                 IO.puts "inside else -> if"
    #                 {elem(List.pop_at(nodesListSorted, x), 0), x}
    #             else
    #                 # IO.puts "inside else -> else"
    #                 {nil, nil}
    #             end
    #         end
    #     if successor != nil do
    #         foundSuccessor(rowList ++ [rowListElement], successor)
    #     else
    #         row(nodeId, nodesListSorted, m, p2powi_minus1, x-1, rowList ++ [rowListElement])
    #     end
    # end
    def getFingerTable(nodeId, nodesListSorted, m) do
        numOfNodes = length(nodesListSorted)
        range = 1..m
        fingerTable=for i <- range do
            # p2powi_minus1=nodeId + round(:math.pow(2,i-1))
            p2powi_minus1_overflow = nodeId + round(:math.pow(2,i-1))
            p2powi_minus1 = rem(p2powi_minus1_overflow, :math.pow(2,m) |> round)
            row = for x <- 0..numOfNodes-1 do
                if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, -1), 0)) do
                    elem(List.pop_at(nodesListSorted, 0), 0)
                else
                    if(p2powi_minus1 >= elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 < elem(List.pop_at(nodesListSorted, x), 0 ) ) do
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
