__precompile__()
module LittleScienceTools
using Statistics
using LinearAlgebra
using Printf
export Roots, Ising, Measuring, Random
include("Measuring/Measuring.jl")
# include("Roots/Roots.jl")
# include("Random/Random.jl")
# include("Ising/Ising.jl")

export interwine
include("utils.jl")

end # module LittleScienceTools
