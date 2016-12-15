__precompile__(true)
module LittleScienceTools

__precompile__(true)
module Measuring
    export Observable
    export Measure
    export add!, mean, var, error
    export obs_from_mean_err_samp, measure_binomial
    export ObsTable
    export set_params_names!, params_names, obs_names, header
    export tomatrix, tomatrices

    using DataStructures
    import Base: &, +, *, error, mean, var, merge
    import Base: setindex!, getindex, start, done, next, endof, eltype, length, haskey

    include("Measuring/observable.jl")
    include("Measuring/measure.jl")
    include("Measuring/obstable.jl")
end # submodule

__precompile__(true)
module RFIM
    export rfim_ground_state

    using FatGraphs

    include("RFIM/mincut.jl")
end # submodule

__precompile__(true)
module Random
    export ParisiRapuano, randperm!, getRNG

    using Base.Random
    import Base: rand, srand

    include("Random/parisi_rapuano.jl")
    include("Random/random.jl")
end #submodule

__precompile__(true)
module Vectors
    export SymVec, ExtVec
    export extend_left!, extend_right!, extend!

    import Base: setindex!, getindex, convert, length #, eltype

    include("Vectors/symvec.jl")
    include("Vectors/extvec.jl")
end #submodule

export interwine
include("utils.jl")

end # module LittleScienceTools
