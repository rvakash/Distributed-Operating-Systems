defmodule GetNeighbor do

  #Getting the line neighbor
  def perfectLine(nodeId,numOfNodes) do
    range =
      cond do
        nodeId == 1 -> [2]
        nodeId == numOfNodes -> [numOfNodes-1]
        nodeId >1 and nodeId < numOfNodes -> [nodeId-1,nodeId+1]
      end
    # IO.inspect(range)
  end

  #Getiing the full neighbors
  def full(nodeId,numOfNodes) do
    range=1..numOfNodes
    range
    |> Enum.filter(fn(value) -> value != nodeId end)
    |> Enum.map(fn(filtered_value) -> filtered_value * 1 end)
    # IO.inspect Neighboringlist
  end
  #Getting the imperfect Line Neighbors
  def imperfectLine(nodeId,numOfNodes) do
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
  #####################Random 2D Neighbor starts here#########################3
  def map2D(numOfNodes) do
    :ets.new(:nodes, [:set, :public, :named_table])
    range=1..numOfNodes
    Enum.each range, fn value ->
      if value==1 or value==2 do
        :ets.insert_new(:nodes, {Integer.to_string(value), nodegen(2)})
      else
        :ets.insert_new(:nodes, {Integer.to_string(value), nodegen(value)})
      end
    end
  end

  def nodegen(nodeId) do
    range1=1..nodeId-1
    x=:rand.uniform()
    y=:rand.uniform()
    if !(is_list(range1)) do
      [x,y]
    else
      Enum.each range1, fn value1 ->
        l1=:ets.lookup(:nodes,Integer.to_string(value1))
        l2=elem(List.first(l1),1)
        x1=List.first(l2)
        y1=List.last(l2)
        cond do
          x==x1 and y==y1 -> nodegen(nodeId)
          true -> nil
        end
      end
      [x,y]
    end
  end

  def getrandom2D(nodeId,numOfNodes) do
    range=1..numOfNodes
    l1=:ets.lookup(:nodes,Integer.to_string(nodeId))
    l2=elem(List.first(l1),1)
    # IO.inspect(l2)
    x1=List.first(l2)
    y1=List.last(l2)
    range
    |> Enum.filter(fn value ->
        l3= :ets.lookup(:nodes,Integer.to_string(value))
        l4=elem(List.first(l3),1)
        x2=List.first(l4)
        y2=List.last(l4)
        d= :math.sqrt( :math.pow((x2-x1),2) + :math.pow((y2-y1),2))
        if d<=0.1 do
          # IO.inspect is_integer(value)
          value
        end
    end)

  end

  def random2D(nodeId,numOfNodes) do
    map2D(numOfNodes)
    l5 = getrandom2D(nodeId,numOfNodes)
    IO.inspect l5
    # l6=Enum.filter(l5,fn y -> y != nodeId end)
    # IO.inspect l6
    inspect :ets.delete(:nodes)
  end



end
