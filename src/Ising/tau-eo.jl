"""
    ground_state_τeo(g::AGraph, J::Vector{Vector{Int}})

Computes the ground state of an Ising model using the τ-EO heuristic.

Returns a vector `σ` taking values ±1.
"""
function ground_state_τeo(g::AGraph, J::Vector{Vector{Int}};
        τ::Float64=1.2,
        maxiters::Int=10000,
        verb::Int = 1)

    N = nv(g)
    σ = fill(1, N)
    hmax = maximum(v->sum(abs,v), J)
    sets = [Set{Int}() for s=1:2hmax+1]
    for i=1:N
        f = frust(g, σ, J[i], i)
        idx = ftoidx(f, hmax)
        push!(sets[idx], i)
    end
    distr = DiscreteDistribution(Float64[(τ-1)/(1-N^(1-τ)) / l^τ for l=1:N])

    Emin = 10^6
    for it=1:maxiters
        for _=1:N
            @assert sum(length, sets) == N
            l = rand(distr)
            idx = searchsortedfirst(cumsum(length.(sets)), l)
            i = rand(sets[idx])

            delete!(sets[idx], i)
            for j in neighbors(g, i)
                fj = frust(g, σ, J[j], j)
                idxj = ftoidx(fj, hmax)
                delete!(sets[idxj], j)
            end

            σ[i] *= -1
            fi = frust(g, σ, J[i], i)
            idx = ftoidx(fi, hmax)
            push!(sets[idx], i)
            for j in neighbors(g, i)
                fj = frust(g, σ, J[j], j)
                idxj = ftoidx(fj, hmax)
                push!(sets[idxj], j)
            end
        end
        if it % 10 == 0 && verb > 0
            E = energy(g,σ, zeros(N), J)/N
            Emin = E < Emin ? E : Emin
            println("it=$it m=",sum(σ)/N, " E=$E Emin=$Emin")
        end
    end
    return σ
end

ftoidx(f::Int, hmax::Int) = hmax - f + 1

function frust(g::AGraph, σ::Vector, J::Vector{Int}, i)
    H = 0
    for (k,j) in enumerate(neighbors(g, i))
        H += J[k] * σ[j]
    end
    return -H*σ[i]
end
