module LittleScienceTools

module Measuring
    using DataStructures

    export Observable
    export Measure
    export add!, mean, var, error
    export obs_from_mean_err_samp, measure_binomial
    export ObsTable
    export set_params_names!

    import Base: &, +, *, error, mean, var
    import Base: setindex!, getindex, start, done, next, endof, eltype, length
    include("Measuring/observable.jl")
    include("Measuring/measure.jl")
    include("Measuring/obstable.jl")
end # submodue


end # module LittleScienceTools
