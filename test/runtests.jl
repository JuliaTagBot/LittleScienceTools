include("../src/LittleScienceTools.jl")
using LittleScienceTools.Measuring
using LittleScienceTools.Random

using Base.Test

println("# Testing module Measuring...")
include("Measuring/observable.jl")
include("Measuring/obstable.jl")
println("# Testing module Random...")
include("Random/parisi_rapuano.jl")
println("# All tests passed!")
