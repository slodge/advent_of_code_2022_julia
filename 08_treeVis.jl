# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

#file = "08-input_test.txt"
file = "08-input.txt"

input = file |>
    readlines 

height = length(input)    
width = length(first(input)) 
matrix = Int64[parse(Int64,line[j]) for line in input, j in 1:width]    

function isVisible(matrix, row, col)
    if row==1 
       return true
    end
    if row==height 
       return true
    end
    if col==1 
        return true
    end
    if col==width 
       return true
    end
 
    value = matrix[row, col]
    hiddenUp = false
    hiddenDown = false
    hiddenLeft = false
    hiddenRight = false
    
    for i in 1:(col - 1)
        if matrix[row, i] >= value
            hiddenLeft = true
        end
    end
    for i in (col + 1):width
        if matrix[row, i] >= value
            hiddenRight = true
        end
    end
    for i in 1:(row - 1)
        if matrix[i, col] >= value
            hiddenUp = true
        end
    end
    for i in (row + 1):height
        if matrix[i, col] >= value
            hiddenDown = true
        end
    end

    if all([hiddenDown, hiddenLeft, hiddenRight, hiddenUp])
        return false
    end

    return true
end

visible = 
    Bool[isVisible(matrix, row, col) for row in 1:height, col in 1:width]    

num_visible = count(visible)

println("Num visible trees ", num_visible)


#part 2

function scenicScore(matrix, row, col)
    if row==1 
        return 0
     end
     if row==height 
        return 0
     end
     if col==1 
         return 0
     end
     if col==width 
        return 0
     end

    value = matrix[row, col]
    scoreUp = 0
    scoreDown = 0
    scoreLeft = 0
    scoreRight = 0
    
    for i in reverse(1:(col - 1))
        scoreLeft =scoreLeft + 1
        if matrix[row, i] >= value
            break
        end
    end
    for i in (col + 1):width
        scoreRight = scoreRight + 1
        if matrix[row, i] >= value
            break
        end
    end
    for i in reverse(1:(row - 1))
        scoreUp = scoreUp + 1
        if matrix[i, col] >= value
            break
        end
    end
    for i in (row + 1):height
        scoreDown = scoreDown + 1
        if matrix[i, col] >= value
            break
        end
    end

    return scoreDown*scoreLeft*scoreRight*scoreUp
end


scores = 
    Int[scenicScore(matrix, row, col) for row in 1:height, col in 1:width]    

max_score = maximum(scores)

println("Max scenic ", max_score)

