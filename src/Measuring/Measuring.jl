__precompile__()
module Measuring
    using DataStructures
    using Compat
    import Base: &, +, *, error, mean, var, merge,
                setindex!, getindex, start, done, next, endof, eltype,
                length, haskey, ==, copy

    export Observable
    export Measure
    export add!, mean, var, error
    export obs_from_mean_err_samp, measure_binomial
    export ObsTable
    export set_params_names!, params_names, obs_names, header
    export tomatrix, tomatrices

    include("observable.jl")
    include("measure.jl")
    include("obstable.jl")
end # submodule
