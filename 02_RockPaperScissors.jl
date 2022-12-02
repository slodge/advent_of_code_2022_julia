# https://adventofcode.com/2022/day/2

# part 2

# let's try
# https://dataframes.juliadata.org/latest/man/comparisons/#Comparison-with-the-R-package-dplyr

#using Pkg
#Pkg.add("DataFrames")
#Pkg.add("DataFramesMeta")
##Pkg.add("CSV")


using DataFrames
using DataFramesMeta
using CSV

input = CSV.File("02-input.txt"; header = ["Them", "Us"])  
    
df = DataFrame(input)

scoring = "Them,Us,ScoreShape,ScoreResult
A,X,1,3
A,Y,2,6
A,Z,3,0
B,X,1,0
B,Y,2,3
B,Z,3,6
C,X,1,6
C,Y,2,0
C,Z,3,3"

score_df = CSV.read(IOBuffer(scoring), DataFrame)

joined_df = innerjoin(df, score_df; on=[:Them, :Us])


pairwise_sum(x, y) = x + y
summed_df = transform(joined_df, [:ScoreShape, :ScoreResult] => pairwise_sum => :Score)

println("The part 1 answer is ", sum(summed_df.Score))



# part 2

shaping = "Them,Result,Us
A,X,Z
A,Y,X
A,Z,Y
B,X,X
B,Y,Y
B,Z,Z
C,X,Y
C,Y,Z
C,Z,X"

input2 = CSV.File("02-input.txt"; header = ["Them", "Result"])  
    
df2 = DataFrame(input2)

shaping_df =  CSV.read(IOBuffer(shaping), DataFrame)

joined_df_1 = innerjoin(df2, shaping_df; on=[:Them, :Result]) 
joined_df_2 = innerjoin(joined_df_1, score_df; on=[:Them, :Us])


pairwise_sum(x, y) = x + y
summed_df = transform(joined_df_2, [:ScoreShape, :ScoreResult] => pairwise_sum => :Score)

println("The part 2 answer is ", sum(summed_df.Score))

