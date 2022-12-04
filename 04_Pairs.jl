# https://adventofcode.com/2022/day/4

using CSV
using DataFrames

#file = "04-input_test.txt"
file = "04-input.txt"
input = CSV.File(file; header = ["First", "Second"], types=[String, String])  



inputs = DataFrame(input)

tmp = split.(inputs.First, '-')
inputs[!, :First_From] = parse.(Int64, getindex.(tmp, 1))
inputs[!, :First_To] =parse.(Int64, getindex.(tmp, 2))

tmp = split.(inputs.Second, '-')
inputs[!, :Second_From] = parse.(Int64, getindex.(tmp, 1))
inputs[!, :Second_To] = parse.(Int64,getindex.(tmp, 2))

test_overlap = function(f_from, f_to, s_from, s_to)
    result = (f_from <= s_from && f_to >= s_to) ||
             (f_from >= s_from && f_to <= s_to)
    Bool.(result) 
end

overlaps = test_overlap.(inputs.First_From, inputs.First_To, inputs.Second_From, inputs.Second_To)

sum(overlaps)

# part 2   



test_overlap_2 = function(f_from, f_to, s_from, s_to)
    are_separate = (f_to < s_from) ||
                   (f_from > s_to)

    !Bool.(are_separate)
end

overlaps = test_overlap_2.(inputs.First_From, inputs.First_To, inputs.Second_From, inputs.Second_To)

sum(overlaps)


