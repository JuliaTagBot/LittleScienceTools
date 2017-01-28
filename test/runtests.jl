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
    include("Roots/newton.jl")

println("# Testing module Random...")
    include("Random/parisi_rapuano.jl")
    include("Random/random.jl")

include("utils.jl")

println("# All tests passed!")
