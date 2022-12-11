# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

#file = "11-input_test.txt"
file = "11-input.txt"

input = file |>
    readlines 

monkey_items = Vector{Vector{Int}}()    
monkey_operations = Vector{String}()
monkey_test_divisible_by = Vector{Int}()
monkey_test_true = Vector{Int}()
monkey_test_false = Vector{Int}()

new_monkey_regex = r"Monkey (\d+):"
starting_items_regex = r"Starting items: (.*)"
operation_regex = r"Operation: new = (.*)"
test_regex = r"Test: divisible by (\d+)"
true_regex = r"If true: throw to monkey (\d+)"
false_regex = r"If false: throw to monkey (\d+)"

current_monkey = -1
for line in input
    new_monkey = match(new_monkey_regex, line)
    starting_items = match(starting_items_regex, line)
    operation_res = match(operation_regex, line)
    test_res = match(test_regex, line)
    true_res = match(true_regex, line)
    false_res = match(false_regex, line)
    if !isnothing(new_monkey)
        new_monkey = parse(Int, new_monkey[1])
        
        if new_monkey != current_monkey + 1
            error("SNEAKY! They didn't put monkeys in order")
        end
        # nothing to do really...
        current_monkey = new_monkey
    elseif !isnothing(starting_items)
        to_add = eval( Meta.parse("[0, $(starting_items[1])]"))
        popfirst!(to_add)
        push!(monkey_items, to_add)
    elseif !isnothing(operation_res)
        push!(monkey_operations, operation_res[1])
    elseif !isnothing(test_res)
        push!(monkey_test_divisible_by, parse(Int, test_res[1]))
    elseif !isnothing(true_res)
        # Julia is 1 based!
        push!(monkey_test_true, parse(Int, true_res[1]) + 1)
    elseif !isnothing(false_res)
        # Julia is 1 based!
        push!(monkey_test_false, parse(Int, false_res[1]) + 1)
    end
end

#ops3 = Meta.parse("function dynamic_go(old) 
#  old * old * old
#end")
#eval(ops3)(12)
lcm = prod(monkey_test_divisible_by)

items_inspected = Vector{Int}()
for i in i:length(monkey_items)
    push!(items_inspected, 0)
end

function process_monkey(i)
    items = monkey_items[i]
    ops = monkey_operations[i] 
    div_by = monkey_test_divisible_by[i]
    tt = monkey_test_true[i]
    tf = monkey_test_false[i]
    #println("")
    #println("monkey ", i)

    # flush the existing queue
    monkey_items[i] = Vector{Int}()
    items_inspected[i] = items_inspected[i] + length(items)

    for item in items
        #println("processing ", item)
        #println("evaluating ", monkey_operations[i])
        to_eval = replace(ops, "old" => item)
        worry = eval(Meta.parse(to_eval))
        #println("old ", item , " to new: ", worry)
        worry = rem(worry, lcm)
        test_res = rem(worry, div_by)
        if test_res == 0
            #println("divisible by ", div_by)
            #println("throwing ", worry ," to monkey ", tt)
            push!(monkey_items[tt], worry)
        else
            #println("not divisible by ", div_by)
            #println("throwing ", worry ," to monkey ", tf)
            push!(monkey_items[tf], worry)
        end 
    end
end

function do_round() 
    for current_monkey in 1:length(monkey_items)
        process_monkey(current_monkey)
    end
end 

for i in 1:10000
    do_round()
end


monkey_items
items_inspected

sorted_items_inspected = sort(items_inspected)


println("Shenanigans was ", prod(last(sorted_items_inspected, 2)))

#thing = 12
#eval( Meta.parse("thing * thing"))
