# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "10-input_test_1.txt"
file = "10-input_test_2.txt"
file = "10-input.txt"

input = file |>
    readlines 


cycles = 0
current = 1
cycle_values = Vector{Int}()

noopRegex = r"noop"
addxRegex = r"addx (-?\d+)"

for line in input
    addx = match(addxRegex, line)
    noop = match(noopRegex, line)
    if !isnothing(addx)
        #println(addx[1])
        
        push!(cycle_values, current)
        push!(cycle_values, current)
        current += parse(Int, addx[1])
        cycles += 2
    elseif !isnothing(noop)
        push!(cycle_values, current)
        cycles += 1
        #println("noop")
    end
end

to_add = 0
for i in [ 20, 60, 100, 140, 180, 220 ]
    to_add += i * cycle_values[i]
end


data = Vector{Vector{Char}}()

for i in 1:6
    this_time = Vector{Char}()
    for j in 1:40
        val = (i-1)*40 + j
        cycle_val = cycle_values[val]
        if (j - cycle_val < 3) && (j >= cycle_val) 
            push!(this_time, '#')
        else
            push!(this_time, '.')
        end
    end
    push!(data, this_time)
end

for d in data
    println(join(d))
end
