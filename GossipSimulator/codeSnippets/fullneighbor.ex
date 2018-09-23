defmodule FullNeighbor do
  def getLineNeighbor(nodeId,numOfNodes) do
    range =
      cond do
        nodeId == 1 -> [2]
        nodeId == numOfNodes -> [numOfNodes-1]
        nodeId >1 and nodeId < numOfNodes -> [nodeId-1,nodeId+1]
      end
    # IO.inspect(range)
  end


  def getNeighborsFull(nodeId,numOfNodes) do
    range=1..numOfNodes
    range
    |> Enum.filter(fn(value) -> value != nodeId end)
    |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
    # IO.inspect Neighboringlist
  end
end
