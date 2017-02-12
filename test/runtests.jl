include("../src/LittleScienceTools.jl")
using LittleScienceTools
using LittleScienceTools.Measuring
using LittleScienceTools.Random
using LittleScienceTools.Roots
using LittleScienceTools.RFIM
using FatGraphs

using Base.Test

println("# Testing module Measuring...")
include("Measuring/observable.jl")
include("Measuring/obstable.jl")

println("# Testing module RFIM...")
include("RFIM/mincut.jl")

println("# Testing module Roots...")
include("Roots/Roots.jl")

println("# Testing module Random...")
#     include("Random/parisi_rapuano.jl")
    include("Random/discrete_distribution.jl")
    include("Random/Random.jl")

include("utils.jl")

println("# All tests passed!")
