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
    import Base: setindex!, getindex, start, done, next, endof, eltype, length, haskey
    include("Measuring/observable.jl")
    include("Measuring/measure.jl")
    include("Measuring/obstable.jl")
end # submodue

module Random
    using Base.Random
    export ParisiRapuano, randperm!, getRNG

    import Base: rand, srand
    include("Random/parisi_rapuano.jl")
    include("Random/random.jl")
end #submodue

module Vectors
    export SymVec, ExtVec
    export extend_left!, extend_right!
    import Base: setindex!, getindex, convert, length #, eltype

    include("Vectors/symvec.jl")
    include("Vectors/extvec.jl")
end #submodule

end # module LittleScienceTools
