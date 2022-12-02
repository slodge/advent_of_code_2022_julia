# https://adventofcode.com/2022/day/1

input = "1-input.txt" |>
    readlines 

# part 1    
current_index = 1
current_sum = 0

max_index = 0
max_sum = 0

for line in input
    if line == ""
        current_index = current_index + 1
        current_sum = 0
    else 
        current_sum = current_sum + parse(Int64, line)
    end


    if current_sum > max_sum
        max_sum = current_sum
        max_index = current_index            
    end
end

println("Max index was ", max_index, " with value ", max_sum)

# part 2

# let's try
# https://dataframes.juliadata.org/latest/man/comparisons/#Comparison-with-the-R-package-dplyr

#using Pkg
#Pkg.add("DataFrames")
#Pkg.add("DataFramesMeta")


using DataFrames

using DataFramesMeta

input = "1-input.txt" |>
    readlines 

df = DataFrame(Values = input)

@chain df begin
    @transform(:IsEmpty = :Values .== "") 
    @transform(:ElfIndex = cumsum(:IsEmpty) .+ 1) 
    @subset(:Values .!= "") 
    @transform(:Values = parse.(Int64, :Values))  
    @select($(Not(:IsEmpty))) 
    @by(:ElfIndex, :Total = sum(:Values))
    @orderby(:Total)
    last(3)
    @combine(:T2 = sum(:Total))
end 


