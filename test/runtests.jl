include("../src/LittleScienceTools.jl")
using LittleScienceTools.Measuring
using LittleScienceTools.Random
using LittleScienceTools.Vectors

using Base.Test

println("# Testing module Measuring...")
    include("Measuring/observable.jl")
    include("Measuring/obstable.jl")

println("# Testing module Random...")
    include("Random/parisi_rapuano.jl")
    include("Random/random.jl")

println("# Testing module Vector...")
    include("Vector/symvec.jl")
    include("Vector/extvec.jl")

println("# All tests passed!")
