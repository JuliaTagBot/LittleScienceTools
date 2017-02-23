using LittleScienceTools.Random
using LittleScienceTools.Ising
using Erdos
using Base.Test

g = Graph(10,20)
Js = random_couplings(g)
@test length(Js) == nv(g)
for i=1:nv(g)
    @test length(Js[i]) == degree(g, i)
end
jdict = Dict{Tuple{Int,Int}, Int}()
for i=1:nv(g)
    for (k,j) in enumerate(neighbors(g,i))
        if i < j
            jdict[(i,j)] = Js[i][k]
        end
    end
end
for i=1:nv(g)
    for (k,j) in enumerate(neighbors(g,i))
        if i > j
            @test Js[i][k] == jdict[(j,i)]
        end
    end
end

include("mincut.jl")
include("tau-eo.jl")
