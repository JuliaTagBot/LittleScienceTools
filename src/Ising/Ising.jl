__precompile__()
module Ising

using DataStructures
export ground_state_mincut, ground_state_ϵgreedy

using FatGraphs

getJ{T}(J::T, i, j, k) = J
getJ{T}(J::Vector{Vector{T}}, i, j, k) = J[i][k]
getJ{T}(J::AbstractMatrix{T}, i, j, k) = J[i,j]

Jtype{T}(J::T) = T
Jtype{T}(J::Vector{Vector{T}}) = T
Jtype{T}(J::AbstractMatrix{T}) = T

function energy(g, σ, h::Vector, J)
    E = 0.
    for i=1:nv(g)
        E -= h[i]*σ[i]
        for (k,j) in enumerate(neighbors(g,i))
            if i < j
                E -= getJ(J, i, j, k) * σ[i] * σ[j]
            end
        end
    end
    return E
end

function random_couplings(g::AGraph)
    adj = adjacency_list(g)
    coupls = [ones(Int, degree(g, i)) for i=1:nv(g)]
    for i=1:nv(g)
        for (k,j) in neighbors(g,i)
            if i < j
                J = rand([-1,1])
                coupls[i][k] = J
                ki = findfirst(adj[j], i)
                coupls[j][ki] =J
            end
        end
    end
end
include("mincut.jl")
include("eps-greedy.jl")


end # submodule
