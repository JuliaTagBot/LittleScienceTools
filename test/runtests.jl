include("../src/LittleScienceTools.jl")
using LittleScienceTools.Measuring
using LittleScienceTools.Random
using LittleScienceTools.Roots
using LittleScienceTools.RFIM
using LittleScienceTools.Vectors
using FatGraphs

using Base.Test

println("# Testing module Measuring...")
    include("Measuring/observable.jl")
    include("Measuring/obstable.jl")

println("# Testing module RFIM...")
    include("RFIM/mincut.jl")

println("# Testing module Roots...")
    include("Roots/newton.jl")

println("# Testing module Random...")
    include("Random/parisi_rapuano.jl")
    include("Random/random.jl")

println("# Testing module Vector...")
    include("Vectors/symvec.jl")
    include("Vectors/extvec.jl")



println("# All tests passed!")
