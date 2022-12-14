# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "14-input_test.txt"
file = "14-input.txt"

input = file |>
    readlines 

points = zeros(Int64, 1000, 1000)

max_y = 0

for line in input    
    parts = split(line, " -> ")
    for i in 1:(length(parts) - 1)
        println(parts[i], ",", parts[i+1])
        previous = parse.(Int64, split(parts[i], ","))
        next = parse.(Int64, split(parts[i + 1], ","))

        x_arr = previous[1] < next[1] ? (previous[1]:next[1]) : next[1]:previous[1]
        for x in x_arr
            points[x, previous[2]] = 1
            println("Drawing ", x, ",", previous[2])
        end
        y_arr = previous[2] < next[2] ? (previous[2]:next[2]) : next[2]:previous[2]
        for y in y_arr
            points[previous[1], y] = 1
            println("Drawing ", previous[1], ",", y)
        end

        max_y = max(max_y, previous[2], next[2])
    end
end

#view(points, 497:504, 1:10)

sand_start = (500, 0)

a_long_time = 1E7

current_sand = nothing
sand_count = 0

for tick in 1:a_long_time
    if isnothing(current_sand)
        current_sand = sand_start
        sand_count = sand_count + 1
        continue
    elseif points[current_sand[1], current_sand[2] + 1] == 0
        current_sand = (current_sand[1], current_sand[2] + 1)
    elseif points[current_sand[1] - 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] - 1, current_sand[2] + 1)
    elseif points[current_sand[1] + 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] + 1, current_sand[2] + 1)
    else
        points[current_sand[1], current_sand[2]] = 2
        current_sand = nothing
    end

    if !isnothing(current_sand) && current_sand[2] >= max_y
        println("Sand $sand_count has escaped - so $(sand_count - 1) came to rest.")
        break
    end

end


# part 2

for i in 1:1000
    points[i, max_y + 2]  = 1
end

for tick in 1:a_long_time
    if isnothing(current_sand)
        current_sand = sand_start
        sand_count = sand_count + 1
        continue
    elseif points[current_sand[1], current_sand[2] + 1] == 0
        current_sand = (current_sand[1], current_sand[2] + 1)
    elseif points[current_sand[1] - 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] - 1, current_sand[2] + 1)
    elseif points[current_sand[1] + 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] + 1, current_sand[2] + 1)
    elseif (current_sand[2] == 0)
        println("Sand $sand_count will block the source.")
        break
    else
        points[current_sand[1], current_sand[2]] = 2
        current_sand = nothing
    end

    #if !isnothing(current_sand) && current_sand[2] >= max_y
    #    println("Sand $sand_count has escaped - so $(sand_count - 1) came to rest.")
    #    break
    #end

end

