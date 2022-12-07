# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "07-input_test.txt"
#file = "07-input.txt"

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

dirTotalSizeList

for i in 1:length(input)
    current_row = input[i]
    q = Queue{Char}()

    for j in 1:length(current_row)
        current_char = current_row[j]
        if length(q) >= uniques
            dequeue!(q)
        end

        enqueue!(q, current_char)
        if length(q) == uniques
            if length(unique(q)) == uniques
                println("Unique found at ", j)
                break
            end
        end  
    end
end

