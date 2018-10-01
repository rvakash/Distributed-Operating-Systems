defmodule GetNeighbor do

  #Getting the line neighbor
  def perfectLine(nodeId,numOfNodes) do
    range =
      cond do
        nodeId == 1 -> [2]
        nodeId == numOfNodes -> [numOfNodes-1]
        nodeId >1 and nodeId < numOfNodes -> [nodeId-1,nodeId+1]
      end
      range
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
        l6=Enum.filter(l5,fn y -> y != nodeId end)
        IO.inspect l6
        inspect :ets.delete(:nodes)
    end

    def torus(nodeId,numOfNodes) do
      x=trunc(:math.ceil(:math.sqrt(numOfNodes)))
      neighborList = cond do
        nodeId==1 -> [nodeId+1,nodeId+x,x,nodeId+((x-1)*(x))]
        nodeId<x -> [nodeId-1,nodeId+1,nodeId+x,nodeId+((x-1)*(x))]
        nodeId==x -> [nodeId-1,nodeId+x,x*x,1]
        nodeId==(x*(x-1))+1 -> [nodeId+1,x*x,nodeId-x,1]
        nodeId>(x*(x-1))+1 and nodeId<(x*x) -> [nodeId+1,nodeId-1,nodeId-x,nodeId-((x-1)*x)]
        nodeId==(x*x) -> [nodeId-1,nodeId-x,x,(x*(x-1))+1]
        rem(nodeId-1,x)==0 -> [nodeId+1,nodeId+x,nodeId-x,nodeId+x-1]
        rem(nodeId,x)==0 and nodeId != x and nodeId != (x*x) -> [nodeId-1,nodeId-x,nodeId+x,nodeId-x+1]
        true -> [nodeId+1,nodeId-1,nodeId-x,nodeId+x]
      end
      neighborList

    end

    def grid3D(nodeId, numOfNodes) do
        rowCount = round(GetRoot.cube(3, numOfNodes))
        IO.puts "#{rowCount}x#{rowCount}x#{rowCount} grid"
        faceNum = getFaceNum3D(nodeId, rowCount, numOfNodes, 0, 1)#nodeId, rowCount, numOfNodes, startFaceNum, faceNum
        IO.puts "nodeId = #{nodeId} faceNum = #{faceNum}"
        i = nodeId
        case faceNum do
            1 ->
                neighboursList =  cond do
                    i == 1 -> [i+1,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                    i == rowCount -> [i-1,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                    i == numOfNodes - rowCount + 1 -> [i+1,i-rowCount, i+:math.pow(rowCount, 2) |> round]
                    i == numOfNodes -> [i-1,i-rowCount, i+:math.pow(rowCount, 2) |> round]
                    i < rowCount -> [i-1,i+1,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                    i > numOfNodes - rowCount + 1 and i < numOfNodes -> [i-1,i+1,i-rowCount, i+:math.pow(rowCount, 2) |> round]
                    rem(i-1,rowCount) == 0 -> [i+1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                    rem(i,rowCount) == 0 -> [i-1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                    true -> [i-1,i+1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round]
                end
                IO.inspect neighboursList, label: "nodeId = #{nodeId}  neighborsList = "

            rowCount ->
                neighboursList =  cond do
                    i == 1 -> [i+1,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                    i == rowCount -> [i-1,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                    i == numOfNodes - rowCount + 1 -> [i+1,i-rowCount, i-:math.pow(rowCount, 2) |> round]
                    i == numOfNodes -> [i-1,i-rowCount, i-:math.pow(rowCount, 2) |> round]
                    i < rowCount -> [i-1,i+1,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                    i > numOfNodes - rowCount + 1 and i < numOfNodes -> [i-1,i+1,i-rowCount, i-:math.pow(rowCount, 2) |> round]
                    rem(i-1,rowCount) == 0 -> [i+1,i-rowCount,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                    rem(i,rowCount) == 0 -> [i-1,i-rowCount,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                    true -> [i-1,i+1,i-rowCount,i+rowCount, i-:math.pow(rowCount, 2) |> round]
                end
                IO.inspect neighboursList, label: "nodeId = #{nodeId}  neighborsList = "

            _ ->
                neighboursList =  cond do
                    i == 1 -> [i+1,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    i == rowCount -> [i-1,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    i == numOfNodes - rowCount + 1 -> [i+1,i-rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    i == numOfNodes -> [i-1,i-rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    i < rowCount -> [i-1,i+1,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    i > numOfNodes - rowCount + 1 and i < numOfNodes -> [i-1,i+1,i-rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    rem(i-1,rowCount) == 0 -> [i+1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    rem(i,rowCount) == 0 -> [i-1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                    true -> [i-1,i+1,i-rowCount,i+rowCount, i+:math.pow(rowCount, 2) |> round, i-:math.pow(rowCount, 2) |> round]
                end
                IO.inspect neighboursList, label: "nodeId = #{nodeId}  neighborsList = "
        end

    end

    def getFaceNum3D(nodeId, rowCount, numOfNodes, startFaceNum, faceNum) do
        if startFaceNum < nodeId and nodeId <= startFaceNum + :math.pow(rowCount, 2) |> round do
            faceNum
        else
            getFaceNum3D(nodeId, rowCount, numOfNodes, startFaceNum + :math.pow(rowCount, 2) |> round, faceNum + 1)
        end
    end

end

defmodule GetRoot do
    def cube(n, x, precision \\ 1.0e-5) do
        f = fn(prev) -> ((n - 1) * prev + x / :math.pow(prev, (n-1))) / n end
        fixed_point(f, x, precision, f.(x))
    end

    defp fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next
    defp fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))
end
