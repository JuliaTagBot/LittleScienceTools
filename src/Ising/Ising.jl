__precompile__()
module Ising
using DataStructures
using Erdos

# using ..Random

import Base: rand
immutable DiscreteDistribution
    p::Vector{Float64}
    P::Vector{Float64} # p(k<=i)
end

function DiscreteDistribution(w)
    @assert all(w .>= 0) "All weights should be non-negative"
    p = w / sum(w)
    P = cumsum(p)
    return DiscreteDistribution(p, P)
end

rand(d::DiscreteDistribution) = searchsortedfirst(d.P, rand())

"""
    randint([rng,] probs::Vector{Float64})

Generate a random integer `i` between `1` and `length(probs)`.
`i` is sampled with probability probs[i].
The vector `probs` is assumed to sum to one.
"""
function randint(rng::AbstractRNG, probs::Vector{Float64})
    r = rand(rng)
    c = 0.
    i = 0
    for p in probs
        i += 1
        c += p
        r <= c && return i
    end
    return 0 #not supposed to arrive here
end

randint(probs::Vector{Float64}) = randint(GLOBAL_RNG, probs)


export  ground_state_mincut, ground_state_ϵgreedy, ground_state_τeo,
        random_couplings

include("ArraySets.jl")
using .ArraySets
function create_J_LUCA(;N::Int = 400, K::Int = -1, seed::Int = 0)
    seed > 0 && srand(seed)
    J = [zeros(Int, N) for i = 1:N]
    if K < 0
        J .= [rand(-1:2:1, N) for i = 1:N]
        for i = 1:N
            Ji = J[i]
            for j = 1:i
                if j == i
                    Ji[j] = 0
                else
                    Ji[j] = J[j][i]
                end
            end
        end
    else
        edges = ArraySet(K*N)
        for i = 1:K*N
            push!(edges, i)
        end
        while edges.t > 0
            iedg = rand(edges)
            delete!(edges, iedg)
            i = (iedg-1)÷K + 1
            j = i
            jedg = 0
            while j == i
                jedg = rand(edges)
                j = (jedg-1)÷K + 1
            end
            delete!(edges, jedg)
            J[i][j] = rand(-1:2:1)
            J[j][i] = J[i][j]
        end
    end
    return J
end

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

end # submodule
