using JLD2
using Plots
using Distributions

function draw_plot(sample, rho)
    xs = [x[1] for x in sample]
    ys = [x[2] for x in sample]
    draw_contour_plot(xs, ys, rho)
    draw_scatter_plot!(xs, ys, rho)
    savefig(string(rho) * "_sample.pdf")
end
function draw_scatter_plot!(xs, ys, rho)
    plot!(xs, ys, seriestype = :scatter, legend = false)
end

function draw_contour_plot(xs, ys, rho)

    # Define covariance
    A = [1 -rho; -rho 1]
    D = MvNormal(inv(A)^2)
    quad = (x, y) -> (pdf(D, [x, y]))

    # Get size of plot and grid
    maxx = maximum(xs)
    minx = minimum(xs)
    maxy = maximum(ys)
    miny = minimum(ys)
    # Get a finer grid for ill-conditioned matrices
    ticx = (maxx - minx) * 1.05 / (3000)
    ticy = (maxy - miny) * 1.05 / (3000)
    ticx = (maxx - minx) * 1.05 / (3000)
    ticy = (maxy - miny) * 1.05 / (3000)
    marginx = (maxx - minx) * 0.025
    marginy = (maxy - miny) * 0.025
    xgrid = (minx-marginx):ticx:(maxx+marginx)
    ygrid = (miny-marginy):ticy:(maxy+marginx)
    X = repeat(reshape(xgrid, 1, :), length(ygrid), 1)
    Y = repeat(ygrid, 1, length(xgrid))

    # Plot the contour
    Z = map(quad, X, Y)
    contourf(xgrid, ygrid, Z, seriescolor = :viridis)
end

function main()
    samples = jldopen("results.jld2")["samples"]
    for (rho, sample) in samples
        draw_plot(sample, rho)
    end
end
main()
