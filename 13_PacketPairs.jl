# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "13-input_test.txt"
file = "13-input.txt"

input = file |>
    readlines 


#

#function parse_row(input)
#    row = Vector()
#    current_stack = Stack{Vector}()
#    push!(current_stack, Vector())
#    current_buffer = ""#

#    for c in input
#        if c == '['
#            push!(current_stack, Vector())
#        elseif c == "]"
#            array = pop!(current_stack)
#            push!(row, current_stack) 
#        elseif c == ","
#        end#

#    end
#end #

#function compare(left, right)
#    
#end


function are_in_correct_order(l, r)
    #println("Comparing ", l , " with ", r)
    if isa(l, Int) && isa(r, Int)
        if l < r
            return 1
        elseif l > r
            return -1
        end

        return 0
    end

    if (!isa(l, Array))
        l = [l]
    end

    if (!isa(r, Array))
        r = [r]
    end

    for i in 1:min(length(l), length(r))
        result = are_in_correct_order(l[i], r[i])
        if (result != 0)
            return result
        end
    end

    if (length(l) < length(r))
        return 1
    end

    if (length(l) > length(r))
        return -1
    end

    return 0

end

correct = Vector{Int}()
current_pair = 1
while (current_pair - 1) * 3 < length(input)
    
    left = input[current_pair*3 - 2]
    right = input[current_pair*3 - 1]

    lefte = eval(Meta.parse(left))
    righte = eval(Meta.parse(right))
    
    #println(lefte)
    #println(righte)
    result = are_in_correct_order(lefte, righte)
    println(current_pair, " ", result)
    if result > 0
        push!(correct, current_pair)
    end

    current_pair = current_pair + 1
end

println("correct are ", correct)
println("Sum of correct is ", sum(correct))


all_packets = Array(filter(function(s) length(s) != 0 end, input))

push!(all_packets, "[[2]]")
push!(all_packets, "[[6]]")

function sort_lt(x, y) 
    if are_in_correct_order(x, y) > 0
        return true
    end
    return false
end

function sort_by(x)
    eval(Meta.parse(x))
end

sorted = sort(all_packets, by=sort_by, lt=sort_lt)

sorted
index_1 = findfirst(x -> x== "[[2]]", sorted)
index_2 = findfirst(x -> x== "[[6]]", sorted)

index_1 * index_2