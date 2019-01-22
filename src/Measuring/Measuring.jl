__precompile__()
module Measuring
    using DataStructures
    using Statistics
    using LinearAlgebra
    using Printf
    using DelimitedFiles: readdlm

    import Statistics: mean, var, std
    import Base: &, +, *, merge,
                setindex!, getindex, eltype,
                length, haskey, ==, copy

    export Observable
    export Measure
    export add!, mean, var, err
    export obs_from_mean_err_samp, measure_binomial
    export ObsTable
    export set_params_names!, params_names, obs_names, header
    export tomatrix, tomatrices


    include("observable.jl")
    include("measure.jl")
    include("obstable.jl")
end # submodule
