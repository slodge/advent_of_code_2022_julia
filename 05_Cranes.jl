# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

#file = "05-input_test.txt"
file = "05-input.txt"

input = file |>
    readlines 
    

# what a syntax
gap_index = findfirst(==(""), input)
pile_index = gap_index - 1
piles = input[pile_index]
indicies = split(piles, " "; keepempty=false) 

if length(indicies) > 9
    error("Can't handle that many indicies")
end

columns = Vector{Stack}()
for i in 1:length(indicies)
    # typeof('a') is Char
    push!(columns, Stack{Char}())
end

pile_start = pile_index -1
for i in reverse(1:pile_start)
    row = input[i]
    for j in 1:length(indicies)
        position = 2 + ((j - 1) * 4)
        entry = row[position]
        if (entry != ' ') 
            push!(columns[j], entry)
        end
    end
end    

columns

moveregex = r"^move (\d*) from (\d) to (\d)$" 
move_index = gap_index +1
for i in move_index:length(input)
    matches = match(moveregex, input[i])
    count = parse(Int, matches[1])
    from = parse(Int, matches[2])
    to = parse(Int, matches[3])
    for j in 1:count
        moving = pop!(columns[from])
        push!(columns[to], moving)
    end
end

columns


for col in columns
    print(first(col))
end
println(" <- the result")


# part 2


columns = Vector{Stack}()
for i in 1:length(indicies)
    # typeof('a') is Char
    push!(columns, Stack{Char}())
end

pile_start = pile_index -1
for i in reverse(1:pile_start)
    row = input[i]
    for j in 1:length(indicies)
        position = 2 + ((j - 1) * 4)
        entry = row[position]
        if (entry != ' ') 
            push!(columns[j], entry)
        end
    end
end    

for i in move_index:length(input)
    matches = match(moveregex, input[i])
    count = parse(Int, matches[1])
    from = parse(Int, matches[2])
    to = parse(Int, matches[3])
    # there are probably better ways... but just want it over with right now!
    temp = Stack{Char}()
    for j in 1:count
        moving = pop!(columns[from])
        push!(temp, moving)
    end
    for j in 1:count
        moving = pop!(temp)
        push!(columns[to], moving)
    end
end


for col in columns
    print(first(col))
end
println(" <- the result")