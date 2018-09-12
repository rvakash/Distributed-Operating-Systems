#####################################################
# Course: COP 5615, Distributed Operating System Principles, University of Florida
# Autors: Akash R Vasishta, Aditya Bhanje 
# Description: Use Actor Model in Elixir to find perfect squares
#              that are sums of consecutive squares
#####################################################
Node.connect :"bhanje@192.168.43.137"
defmodule Proj1 do
    def scheduler do
    	argList=Enum.map(System.argv,fn x-> String.to_integer(x) end)
	n = Enum.at(argList,0)
	k = Enum.at(argList,1)
	use_multiple_machines = Enum.at(argList,2)    
	actorNum = n
        if use_multiple_machines == 1 do
            create_workers(n, k, actorNum, 20000, 0, use_multiple_machines)
        else
            create_workers(n, k, actorNum, 20000, 0, 0)
        end
    end
    
    def exitWorkers(0), do: nil

    def exitWorkers(numOfWorkers) do
        receive do
            exitValue -> inspect(exitValue)
            exitWorkers(numOfWorkers - 1)
        end
    end

    def create_workers(_, _, -1, _, numOfWorkers, _) do
        exitWorkers(numOfWorkers)
    end

    def create_workers(n, k, actorNum, workUnit, numOfWorkers, use_multiple_machines) do
        if actorNum < 1 do 
            create_workers(n, k, -1, workUnit, numOfWorkers, use_multiple_machines)
        else
            rem = rem(actorNum, workUnit)
            actualWorkUnit = 
                if rem == 0 do
                    workUnit
                else
                    rem
                end
            if use_multiple_machines == 1 do
                if rem(n, 2) == 0 do
                    pid = spawn(Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                    inspect(pid)
                else
                    pid = Node.spawn(:"bhanje@192.168.43.137", Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                    inspect(pid)
                end
                # To run on multiple machines add more conditions like below
                # if rem(n, 3) == 0 do
                #     pid = spawn(Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                #     inspect(pid)
                # else if rem(n, 3) == 1 do
                #     pid = Node.spawn(:"bhanje@192.168.43.137", Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                #     inspect(pid)
                # else
                #     pid = Node.spawn(:"rahul@192.168.43.138", Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                #     inspect(pid)
                # end
            else
                pid = spawn(Proj1, :worker, [actorNum, k, actualWorkUnit, self()])
                inspect(pid)
            end
            create_workers(n-1, k, actorNum - actualWorkUnit, workUnit, numOfWorkers + 1, use_multiple_machines)
        end
    end

#######################################################
# Worker processes start here
#######################################################
    # def worker(_, _, 0), do: nil

    def worker(_, _, 0, parentPID) do
        send parentPID, 0
    end

    def worker(actorNum, k, actualWorkUnit, parentPID) do
        workerCalculate(actorNum, k)
        worker(actorNum - 1, k, actualWorkUnit - 1, parentPID)
    end

    def workerCalculate(actorNum, k) do
        upperLimit = actorNum + k - 1
        lowerLimit = actorNum - 1
        suL = div((upperLimit * (upperLimit + 1) * ((2 * upperLimit) + 1)), 6)
        slL = div((lowerLimit * (lowerLimit + 1) * ((2 * lowerLimit) + 1)), 6)
        sN = suL - slL
        perfectSquare = :math.sqrt(sN)
        floorOfperfectSquare = :math.floor(perfectSquare)
        if perfectSquare == floorOfperfectSquare do
            IO.puts "#{actorNum}"
        end

    end
end
