defmodule FullNeighbor do

  #Getting the line neighbor
  def getLineNeighbor(nodeId,numOfNodes) do
    range =
      cond do
        nodeId == 1 -> [2]
        nodeId == numOfNodes -> [numOfNodes-1]
        nodeId >1 and nodeId < numOfNodes -> [nodeId-1,nodeId+1]
      end
    # IO.inspect(range)
  end

  #Getiing the full neighbors
  def getNeighborsFull(nodeId,numOfNodes) do
    range=1..numOfNodes
    range
    |> Enum.filter(fn(value) -> value != nodeId end)
    |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
    # IO.inspect Neighboringlist
  end
  #Getting the imperfect Line Neighbors
  def getImperfectLineNeighbor(nodeId,numOfNodes) do
    range =
      cond do
        nodeId == 1 -> [2,:rand.uniform(numOfNodes-2)+2]
        nodeId == numOfNodes -> [numOfNodes-1,:rand.uniform(numOfNodes-2)]
        nodeId >1 and nodeId < numOfNodes -> randomNo(nodeId,numOfNodes)
      end
  end
 #random neighbor generation
  def randomNo(nodeId,numOfNodes) do
    x=:rand.uniform(numOfNodes)
    cond do
      x==(nodeId-1) or x==(nodeId+1) -> randomNo(nodeId,numOfNodes)
      true-> [nodeId-1,nodeId+1,x]
    end
  end
end
