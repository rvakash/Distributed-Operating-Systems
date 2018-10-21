defmodule CodeSnippets do

  def getFingerTable(nodeId, nodesListSorted, m) do
    numOfNodes = length(nodesListSorted)
    # range = 1..m
    bits=m
    :lists.reverse(fingerTable(nodeId, nodesListSorted, m, numOfNodes-1, [],bits))
end

def fingerTable(_, _, 0, _, fingerTableList,_) do
    fingerTableList
end

def fingerTable(nodeId, nodesListSorted, m, numOfNodes, fingerTableList,bits) do
    p2powi_minus1_overflow = nodeId + round(:math.pow(2,m-1))
    p2powi_minus1 = rem(p2powi_minus1_overflow, :math.pow(2,bits) |> round)
    {rowList, successor} = row(nodeId, nodesListSorted, m, p2powi_minus1, numOfNodes)
    # rowafter_removenil = Enum.find(rowList, fn(elem) -> elem != nil end)
    fingerTable(nodeId, nodesListSorted, m-1, successor, fingerTableList ++ [rowList],bits)
end

# def row(_, _, _, _, 0) do
#     {rowList, -1}
# end

def foundSuccessor(rowList, successor) do
    {rowList, successor}
end

def row(nodeId, nodesListSorted, m, p2powi_minus1, start) do
    IO.puts "Entered here....."
    x = start
    {rowListElement, successor} =
       if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, -1), 0)) do
            # IO.puts "inside if"
            {elem(List.pop_at(nodesListSorted, 0), 0), 0}
        else
            # IO.puts "inside else p2powi_minus1 = #{p2powi_minus1}, x-1 = #{elem(List.pop_at(nodesListSorted, x-1), 0)}, x = #{elem(List.pop_at(nodesListSorted, x), 0 )} "
            cond do
              p2powi_minus1 < elem(List.pop_at(nodesListSorted, 0), 0) -> {elem(List.pop_at(nodesListSorted, 0), 0),0}
              p2powi_minus1 >= elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 < elem(List.pop_at(nodesListSorted, x), 0 ) -> {elem(List.pop_at(nodesListSorted, x), 0),x}
              true -> {nil,nil}
            end

        end
    if successor != nil do
        foundSuccessor(rowListElement, successor)
    else
        row(nodeId, nodesListSorted, m, p2powi_minus1, x-1)
    end
end
    # def getFingerTable(nodeId, nodesListSorted, m) do
    #     numOfNodes = length(nodesListSorted)
    #     range = 1..m
    #     fingerTable=for i <- range do
    #         p2powi_minus1_overflow=nodeId + round(:math.pow(2,i-1))
    #         p2powi_minus1 = rem(p2powi_minus1_overflow, :math.pow(2,m) |> round)
    #         # IO.puts p2powi_minus1
    #         row = for x <- 0..numOfNodes-1 do
    #             if(p2powi_minus1 > elem(List.pop_at(nodesListSorted, -1), 0)) do
    #                 elem(List.pop_at(nodesListSorted, 0), 0)
    #             else
    #               cond do
    #                 p2powi_minus1 < elem(List.pop_at(nodesListSorted, 0), 0) -> elem(List.pop_at(nodesListSorted, 0), 0)
    #                 p2powi_minus1 >= elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 < elem(List.pop_at(nodesListSorted, x), 0 ) -> elem(List.pop_at(nodesListSorted, x), 0)
    #                 true -> nil
    #               end


    #               # if(p2powi_minus1 >= elem(List.pop_at(nodesListSorted, x-1), 0) and p2powi_minus1 < elem(List.pop_at(nodesListSorted, x), 0 ) ) do
    #               #       IO.puts "Entered here"
    #               #       elem(List.pop_at(nodesListSorted, x), 0)
    #               #   end
    #             end
    #         end
    #         rowafter_removenil =Enum.find(row, fn(elem) -> elem != nil end)
    #     end
    # end

    def getKeys(prev,curr,keysList) do
        Enum.filter(keysList, fn(x) -> x > prev and x <= curr end)
    end
end
