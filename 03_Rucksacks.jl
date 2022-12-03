# https://adventofcode.com/2022/day/1

input = "03-input.txt" |>
    readlines 

# part 1    

using DataFrames

inputs = DataFrame(Raw = input)

function first_half_string(x)
    x[1:(length.(x) ÷ 2)]
end

function second_half_string(x)
    x[(1 + length(x) ÷ 2):length(x)]
end

# the brackets in the middle here are confusing...
# https://stackoverflow.com/a/70337069/373321
step1 =
    transform(inputs, :Raw => ((x) -> first_half_string.(x)) => :Left)
 
step2 =
    transform(step1, :Raw => ((x) -> second_half_string.(x)) => :Right)

step3 = 
    transform(step2, :Left => ((x) -> split.(x, "")) => :Left)

step4 = 
    transform(step3, :Right => ((x) -> split.(x, "")) => :Right)

step5 = 
    transform(step4, [:Left, :Right] => ((x, y) -> intersect.(x, y)) => :Intersection)

step6 = 
    transform(step5, :Intersection => ((x) -> only.(x)) => :Result)

function value(x) 
    if (x >= 'a') 
        return x - 'a' + 1
    end
    return x - 'A' + 27
end 

#value('a')
#value('A')

step7 = 
    transform(step6, :Result => ((x) -> value.(only.(String.(x)))) => :Num)

step8 = 
    combine(step7, :Num => sum => :TheResult)

println("The result is ", step8.TheResult)



# part 2

inputs.GroupId = 1 .+ div.(0:(nrow(inputs)-1), 3) 
inputs.Raw
step1 = 
    transform(inputs, :Raw => ((x) -> split.(x, "")) => :Split)

step1.SplitC = map((x) -> String.(x), step1.Split)

grouped = groupby(step1, :GroupId)

# There should be a much easier way to do this grouping!
# Julia driving me mad!
step2 = combine(grouped) do df  
    Intersect = intersect(df.SplitC[1],df.SplitC[2],df.SplitC[3])
end
        
step2.x1

step3 = value.(only.(step2.x1))

println("Answer is... ", sum(step3))
