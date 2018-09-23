defmodule FullNeighbor do
  def getNeighborsFull(actor,numNodes) do
    range=1..numNodes
    range
    |> Enum.filter(fn(value) -> value != actor end)
    |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
    # IO.inspect Neighboringlist
  end
end
