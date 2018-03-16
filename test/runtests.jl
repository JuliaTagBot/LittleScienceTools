using LittleScienceTools
using LittleScienceTools.Measuring
using LittleScienceTools.Random
using LittleScienceTools.Roots
using LittleScienceTools.Ising
using Compat
using Erdos
using Base.Test

@testset "Measuring" begin
    include("Measuring/observable.jl")
    include("Measuring/obstable.jl")
end

@testset "Ising" begin
    include("Ising/runtests.jl")
end

@testset "Roots" begin
    include("Roots/Roots.jl")
end

@testset "Random" begin
#     include("Random/parisi_rapuano.jl")
    include("Random/discrete_distribution.jl")
    include("Random/Random.jl")
end

@testset "utils" begin
    include("utils.jl")
end
