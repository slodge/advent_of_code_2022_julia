# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "12-input.txt"
#file = "12-input_test.txt"

input = file |>
    readlines 

height_grid = Vector{Vector{Int}}()
distance_grid = Vector{Vector{Int}}()

start_pos = (-1, -1)
end_pos = (-1, -1)

j = 0
for line in input
    l = Vector{Int}()
    dl = Vector{Int}()
    j = j + 1
    i = 0
    for c in line
        i = i + 1 
        d = -1
        if c == 'E'
            c = Int('z')
            end_pos = (i, j) 
        elseif c == 'S'
            c = Int('a')
            start_pos = (i, j) 
            d = 0
        end
        push!(l, c)
        push!(dl, d)
    end    
    push!(height_grid, l)
    push!(distance_grid, dl)
end

this_time = Vector{Tuple{Int, Int}}()
push!(this_time, start_pos)

max_x = length(input[1])
max_y = length(input)

loop_count = 0
for thing in 1:(max_x * max_y)
    last_time = this_time
    this_time = Vector{Tuple{Int, Int}}()
    loop_count = loop_count + 1

    println("Considering $(loop_count) with $(length(last_time)) points")

    function consider_point(height, x, y)
        if x < 1 || x > max_x || y < 1 || y > max_y
            return
        end

        if distance_grid[y][x] > -1
            return
        end

        height_this_time = height_grid[y][x]
        if (height_this_time > height + 1)
            return
        end

        distance_grid[y][x] = loop_count
        new_point = (x, y)
        println("Adding ", new_point, " distance ", loop_count)
        push!(this_time, new_point)
    end

    for p in last_time
        x = p[1]
        y = p[2]

        height = height_grid[y][x]
        println("Considering ", x, ",", y, " with height ", height)
        consider_point(height, x-1, y)
        consider_point(height, x+1, y)
        consider_point(height, x, y-1)
        consider_point(height, x, y+1)
        println("Length of this_time is ", length(this_time))
    end

    if length(this_time) == 0
        break
    end
end

distance_grid

distance_to_target = distance_grid[end_pos[2]][end_pos[1]] 

distance_to_target
