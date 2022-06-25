using LinearAlgebra
using Random
using JLD2
using Profile
using PProf

function draw_running_average(num_iterations, rho)
    current_iterate = zeros(2)
    running_sum = current_iterate
    for k in 1:(num_iterations-1)
        current_iterate = current_iterate -
                          1 / k^0.75 * (current_iterate - rho * [current_iterate[2]; current_iterate[1]] + randn(2))
        running_sum += current_iterate
    end
    return 1 / sqrt(num_iterations) * running_sum
end


function main()
    Random.seed!(2625)
    rhos = [0.0, 0.25, 0.5, 0.75, 0.9]
    sample_size = 300
    num_iter = Int(1e7)
    samples = Dict()
    for rho in rhos
        samples[rho] = Vector{Vector{Float64}}(undef, sample_size)
        println("Generating sample for rho = " * string(rho))
        Threads.@threads for t in 1:sample_size
            println("\tSample ", t)
            samples[rho][t] = draw_running_average(num_iter, rho)
        end
        jldsave("results.jld2"; samples)
    end
end

main()
