using JLD2
using Plots
using Random
using Distributions
using StatsPlots


function draw_plot(sample, rho)
    Random.seed!(2625)
    # Define asymptotic distribution
    A = [1 -rho; -rho 1]
    D = MvNormal(inv(A)^2)

    # Draw sample
    n = length(sample)
    asym_sam = rand(D, n)

    # Plot asymptotic density plot
    marginalkde(asym_sam[1, :], asym_sam[2, :])
    savefig(string(rho) * "_asymptotic.pdf")

    # Plot empirical density plot
    marginalkde([x[1] for x in sample], [x[2] for x in sample])
    savefig(string(rho) * "_empirical.pdf")
end

function main()
    samples = jldopen("results.jld2")["samples"]
    for (rho, sample) in samples
        draw_plot(sample, rho)
    end
end
main()
