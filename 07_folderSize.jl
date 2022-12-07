# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

#file = "07-input_test.txt"
file = "07-input.txt"

input = file |>
    readlines 

path = Vector{String}()
pushfirst!(path, "\$")

cdRegex = r"\$ cd (.*)"
dirRegex = r"dir (.*)"
fileRegex = r"(\d+) (.*)"

dirOwningList = Dict{String, Vector{String}}()
dirTotalSizeList = Dict{String, Int64}()
fileSizeList = Dict{String, Int64}()

for line in input
    cdMatch = match(cdRegex, line)
    dirMatch = match(dirRegex, line)
    fileMatch = match(fileRegex, line)

    if !isnothing(cdMatch)
        if (cdMatch[1] == "/") 
            empty!(path)
            pushfirst!(path, "\$")
        elseif (cdMatch[1] == "..") 
            pop!(path)
        else 
            push!(path, cdMatch[1])
        end
        println(path)
    end
    if !isnothing(dirMatch)
        currentPath = join(path, "/")
        if !haskey(dirOwningList, currentPath)
            dirOwningList[currentPath] = Vector{String}()
        end
        
        subPath = "$currentPath/$(dirMatch[1])"
        push!(dirOwningList[currentPath], subPath)
    end
    if !isnothing(fileMatch)
        println("fileMatch")
        currentPath = join(path, "/")
        filePath = "$currentPath/$(fileMatch[2])"
        fileSize = parse(Int64, fileMatch[1])
        fileSizeList[filePath] = fileSize  

        for i in 1:length(path)
            currentPath = join(Iterators.take(path, i), "/")
            if !haskey(dirTotalSizeList, currentPath)
                dirTotalSizeList[currentPath] = 0
            end
            dirTotalSizeList[currentPath] = dirTotalSizeList[currentPath]  + fileSize
        end
    end
end

df = DataFrame(dirTotalSizeList) 
stacked = stack(df, 1:length(dirTotalSizeList); variable_name=:Path, value_name=:Size)
under100k = filter(:Size => ((x) -> x <= 100000), stacked)
combine(under100k, :Size => sum)

# part 2

# we need 30_000_000

total_size = 70_000_000
size_needed = 30_000_000
size_available = total_size - dirTotalSizeList["\$"]
size_to_free_up = size_needed - size_available

big_enough = filter(:Size => ((x) -> x >= size_to_free_up), stacked)
arranged = sort(big_enough, :Size)
first(arranged)