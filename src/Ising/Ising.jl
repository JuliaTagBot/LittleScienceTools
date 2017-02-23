__precompile__()
module Ising
using ..Random
using DataStructures

using Erdos

export  ground_state_mincut, ground_state_ϵgreedy, ground_state_τeo,
        random_couplings


getJ{T}(J::T, i, j, k) = J
getJ{T}(J::Vector{Vector{T}}, i, j, k) = J[i][k]
getJ{T}(J::AbstractMatrix{T}, i, j, k) = J[i,j]

Jtype{T}(J::T) = T
Jtype{T}(J::Vector{Vector{T}}) = T
Jtype{T}(J::AbstractMatrix{T}) = T

function energy{TH}(g::AGraph, σ::Vector, h::Vector{TH}, Js)
    E = zero(promote_type(Jtype(Js), TH))
    for i=1:nv(g)
        E -= h[i]*σ[i]
        for (k,j) in enumerate(neighbors(g,i))
            if i < j
                E -= getJ(Js, i, j, k) * σ[i] * σ[j]
            end
        end
    end
    return E
end

function random_couplings(g::AGraph)
    adj = adjacency_list(g)
    coupls = [ones(Int, degree(g, i)) for i=1:nv(g)]
    for i=1:nv(g)
        for (k,j) in enumerate(neighbors(g,i))
            if i < j
                J = rand([-1,1])
                coupls[i][k] = J
                ki = findfirst(adj[j], i)
                coupls[j][ki] = J
            end
        end
    end
    return coupls
end

function graph_and_couplings(Js::Vector{Vector{Int}})
    n = length(Js)
    g = Graph(n)
    for i=1:n
        neigs = find(i->i!=0, Js[i])
        for j in neigs
            if i < j
                add_edge!(g, i, j)
            end
        end
    end

    myJ = [zeros(Int,degree(g,i)) for i=1:nv(g)]
    for i=1:n
        for (k,j) in enumerate(neighbors(g,i))
            myJ[i][k] = Js[i][j]
        end
    end
    return g, myJ
end

include("mincut.jl")
include("tau-eo.jl")
# include("eps-greedy.jl")


end # submodule
