# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

#file = "06-input_test.txt"
file = "06-input.txt"

# part 1
uniques = 4
# part 2
uniques = 14

input = file |>
    readlines 



for i in 1:length(input)
    current_row = input[i]
    q = Queue{Char}()

    for j in 1:length(current_row)
        current_char = current_row[j]
        if length(q) >= uniques
            dequeue!(q)
        end

        enqueue!(q, current_char)
        if length(q) == uniques
            if length(unique(q)) == uniques
                println("Unique found at ", j)
                break
            end
        end  
    end
end

