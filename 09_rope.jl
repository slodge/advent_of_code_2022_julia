# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "09-input_test.txt"
file = "09-input.txt"

input = file |>
    readlines 

pos_H = (0, 0)
pos_T = (0, 0)


function new_tail(pos_H, pos_T)
    new_x = pos_T[1]
    new_y = pos_T[2]

    x_diff = pos_H[1] - pos_T[1] 
    y_diff = pos_H[2] - pos_T[2]
    if abs(x_diff) > 1 && abs(y_diff) > 1
        new_x = new_x + sign(x_diff)*(abs(x_diff) - 1) 
        new_y = new_y + sign(y_diff)*(abs(y_diff) - 1) 
    elseif abs(x_diff) > 1
        new_x = new_x + sign(x_diff)*(abs(x_diff) - 1) 
        new_y = new_y + y_diff 
    elseif abs(y_diff) > 1
        new_x = new_x + x_diff
        new_y = new_y + sign(y_diff)*(abs(y_diff) - 1) 
    end
    
    (new_x, new_y)
end

moveRegex = r"(.*) (\d+)"

tail_positions = DataFrame(X = 0, y = 0)

for line in input
    #println(line)
    moveMatch = match(moveRegex, line)

    #println(moveMatch[1])
    #println(moveMatch[2])

    direction = moveMatch[1]
    stepCount = parse(Int64, moveMatch[2])
    for i in 1:stepCount
        if direction == "U"
            pos_H = (pos_H[1], pos_H[2] - 1)
        elseif direction == "D"
            pos_H = (pos_H[1], pos_H[2] + 1)
        elseif direction == "L"
            pos_H = (pos_H[1] - 1, pos_H[2])
        elseif direction == "R"
            pos_H = (pos_H[1] + 1, pos_H[2])
        else
            # uh oh!
        end
        pos_T = new_tail(pos_H, pos_T)
        println("H is ", pos_H, ", tail is ", pos_T)
        push!(tail_positions, [ pos_T[1], pos_T[2] ]  )
    end
end

println("Answer is ", nrow(unique(tail_positions)))






