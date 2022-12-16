# https://adventofcode.com/2022/day/5

using CSV
using DataFrames
#using Pkg
#Pkg.add("DataStructures")
using DataStructures

file = "15-input_test.txt"
file = "15-input.txt"

input = file |>
    readlines 

line_regex = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"


results = Vector()
y_vals = Vector{Int}()
x_vals = Vector{Int}()
for line in input    
    line_match = match(line_regex, line)

    push!(x_vals, parse(Int, line_match[1]))
    push!(x_vals, parse(Int, line_match[3]))
    push!(y_vals, parse(Int, line_match[2]))
    push!(y_vals, parse(Int, line_match[4]))
    push!(results, (parse(Int, line_match[1]) , parse(Int, line_match[2]), parse(Int, line_match[3]), parse(Int, line_match[4])))
end


results


y = 2000000
ranges = Vector()
min_x = 0
max_x = 0

for result in results
    sensor_x = result[1]
    sensor_y = result[2]
    beacon_x = result[3]
    beacon_y = result[4]

    dist_y = abs(sensor_y - beacon_y)
    dist_x = abs(sensor_x - beacon_x)
    dist = dist_x + dist_y

    dist_target_y = abs(sensor_y - y)
    x_extent = dist - dist_target_y
    if x_extent >= 0
        #println((sensor_x - x_extent))
        #println((sensor_x + x_extent))
        push!(ranges, (sensor_x - x_extent):(sensor_x + x_extent)) 
        min_x = min(min_x, sensor_x - x_extent)
        max_x = max(max_x, sensor_x + x_extent)
    end
end

overall_range = zeros(Int, 1 + max_x - min_x)

overall_range
num_impossible = sum(overall_range)


beacons = Vector() 
for r in results
    if (r[4] == y)
        push!(beacons, r[3])
    end
end

num_beacons = length(unique(beacons))

answer = num_impossible - num_beacons



# part 2

min_x = 0
max_x = 4000000
min_y = 0
max_y = 4000000


candidates = Vector()
candidates2 = Vector()

for result in results
    sensor_x = result[1]
    sensor_y = result[2]
    beacon_x = result[3]
    beacon_y = result[4]

    dist_y = abs(sensor_y - beacon_y)
    dist_x = abs(sensor_x - beacon_x)
    #println(dist_x, ", ", dist_y)

    dist = dist_x + dist_y

    function add_if_valid(x, y)
        if x < min_x
             return
        end
        if x > max_x
             return
        end
        if y < min_y 
            return
        end
        if y > max_y 
            return
        end
        push!(candidates, (x, y))
        push!(candidates2, x * 4000000 + y)
        
    end

    for i in 0:(dist+1)
        x = i
        y = dist + 1 - i
        add_if_valid(sensor_x - x, sensor_y + y)
        add_if_valid(sensor_x - x, sensor_y - y)
        add_if_valid(sensor_x + x, sensor_y + y)
        add_if_valid(sensor_x + x, sensor_y - y)
    end
end

u_candidates = unique(candidates)
i = 0
last_said = 0
for u in u_candidates
    is_ok = true
    for result in results
        # could definitely make this code quicker!
        sensor_x = result[1]
        sensor_y = result[2]
        beacon_x = result[3]
        beacon_y = result[4]
    
        dist_y = abs(sensor_y - beacon_y)
        dist_x = abs(sensor_x - beacon_x)
        #println(dist_x, ", ", dist_y)
    
        dist = dist_x + dist_y

        dist_u_x = abs(u[1] - sensor_x)
        dist_u_y = abs(u[2] - sensor_y)
        dist_u = dist_u_x + dist_u_y

        if (dist_u <= dist)
            is_ok = false
            break
        end

    end
    if is_ok
        println("Found one ", u[1], ", ", u[2])
        println("Found one ", u[1] * 4000000 + u[2])
        break
    end
    i = i+1
    pcnt = i*100 ÷ length(u_candidates)
    if pcnt > last_said
        println("Done ", last_said, "%")
        last_said = pcnt
    end


end
























# no idea what is below... post beer coding, eh?
# Ballmer peak does not exist?!

#mapped = map((t) -> t[1]*4000000 + t[2], candidates)

#using Pkg
#Pkg.add("StatsBase")
data = DataFrame(C = candidates2)
counted = combine(groupby(data, [:C]), nrow => :count)
sorted = sort!(counted, :count)
using StatsBase
StatsBase.mode(mapped)
# 329457976421 - too low!

hit = Vector()
hit_beacon = Vector()
y = 2000000
for result in results
    sensor_x = result[1]
    sensor_y = result[2]
    beacon_x = result[3]
    beacon_y = result[4]

    dist_x = abs(sensor_x - beacon_x)
    dist_y = abs(sensor_y - beacon_y)

    dist_target = dist_x + dist_y

    if (beacon_y == y)
        push!(hit_beacon, beacon_x)
    end

    for x in minimum(x_vals):maximum(x_vals)
        dist = abs(x - sensor_x) + abs(y - sensor_y)
        if dist <= dist_target
            push!(hit, x)
        end
    end
end

not_possible = sort(unique(hit))
beacons = unique(hit_beacon)

result = length(not_possible) - length(beacons)
result


x_range = maximum(x_vals) - minimum(x_vals) 
y_range = maximum(y_vals) - minimum(y_vals) 
x_offset = minimum(x_vals)
y_offset = minimum(y_vals)


grid = zeros(Int64, x_range + 1, y_range + 1)

for result in results
    sensor_x = result[1] - x_offset + 1
    sensor_y = result[2] - y_offset + 1 
    beacon_x = result[3] - x_offset + 1
    beacon_y = result[4] - y_offset + 1

    dist_x = abs(sensor_x - beacon_x)
    dist_y = abs(sensor_y - beacon_y)

    dist_target = dist_x + dist_y

    for x in 1:x_range
        for y in 1:y_range
            if abs(x - sensor_x) + abs(y - sensor_y) <= dist_target
                println("Setting ", x , ", ", y)
                grid[x, y] = 1 
            end
        end
    end

    grid[sensor_x, sensor_y] = 2
    grid[beacon_x, beacon_y] = 3 

end

sum(grid[:, 10 + y_offset])

# nbg!

nbg = Vector() 
y = 10
for result in results
    sensor_x = result[1] 
    sensor_y = result[2]  
    beacon_x = result[3]
    beacon_y = result[4]
    
    dist_x = abs(sensor_x - beacon_x)
    dist_y = abs(sensor_y - beacon_y)

    dist_target = dist_x + dist_y
    
    for x in -1000:1000
        dist = abs(x - sensor_x) + abs(y - sensor_y)
        if dist <= dist_target
            push!(nbg, x)
        end
    end
end

unique(nbg)


#view(points, 497:504, 1:10)

sand_start = (500, 0)

a_long_time = 1E7

current_sand = nothing
sand_count = 0

for tick in 1:a_long_time
    if isnothing(current_sand)
        current_sand = sand_start
        sand_count = sand_count + 1
        continue
    elseif points[current_sand[1], current_sand[2] + 1] == 0
        current_sand = (current_sand[1], current_sand[2] + 1)
    elseif points[current_sand[1] - 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] - 1, current_sand[2] + 1)
    elseif points[current_sand[1] + 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] + 1, current_sand[2] + 1)
    else
        points[current_sand[1], current_sand[2]] = 2
        current_sand = nothing
    end

    if !isnothing(current_sand) && current_sand[2] >= max_y
        println("Sand $sand_count has escaped - so $(sand_count - 1) came to rest.")
        break
    end

end


# part 2

for i in 1:1000
    points[i, max_y + 2]  = 1
end

for tick in 1:a_long_time
    if isnothing(current_sand)
        current_sand = sand_start
        sand_count = sand_count + 1
        continue
    elseif points[current_sand[1], current_sand[2] + 1] == 0
        current_sand = (current_sand[1], current_sand[2] + 1)
    elseif points[current_sand[1] - 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] - 1, current_sand[2] + 1)
    elseif points[current_sand[1] + 1, current_sand[2] + 1] == 0
        current_sand = (current_sand[1] + 1, current_sand[2] + 1)
    elseif (current_sand[2] == 0)
        println("Sand $sand_count will block the source.")
        break
    else
        points[current_sand[1], current_sand[2]] = 2
        current_sand = nothing
    end

    #if !isnothing(current_sand) && current_sand[2] >= max_y
    #    println("Sand $sand_count has escaped - so $(sand_count - 1) came to rest.")
    #    break
    #end

end

