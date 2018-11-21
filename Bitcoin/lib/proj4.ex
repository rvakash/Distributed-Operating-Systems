#####################################################
# Course: COP 5615, Distributed Operating System Principles, University of Florida
# Autors: Akash R Vasishta, Aditya Bhanje
# Description: Bitcoin
# Instructions to run the project
# 1) $mix compile
# 2) $mix run -e Proj4.main
#####################################################
defmodule Proj4 do
    def main do
        IO.puts "Hello World!!"
        :world
    end

    def mineBitcoins(serverId, threshold) do
        # IO.puts "here"
        message = "rvakash" <> randomizer(9)
        temporary = :crypto.hash(:sha256, message) |> Base.encode16 |> String.downcase
        if(String.slice(temporary, 0, threshold) === String.duplicate("0", threshold)) do
            IO.puts "Found a bitcoin!!"
            send(serverId, {:bitCoin, message <> "\t" <> temporary})
        else
            mineBitcoins(serverId, threshold)
        end
    end

    def randomizer(length) do
        :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.downcase
    end
end