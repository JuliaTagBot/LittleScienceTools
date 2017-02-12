"""
    ground_state_epsgreedy(g::AGraph, h::Vector, J)

Computes the ground state of an Ising model using an ϵ-greed heuristic.

Coupling `J` can be in the form of a costant, a matrix, or a
vector of vectors (adjacency list style).

Returns a vector `σ` taking values ±1.
"""
function ground_state_τeo(g::AGraph, h::Vector, J;
        τ::Float64=1.2,
        maxiters::Int=1000,
        verb::Int = 1)

    N = nv(g)
    σ = fill(1, N)
    frust = mutable_binary_maxheap(Float64)
    ϵstep = ϵstep < 0 ? ϵ / maxiters : ϵstep
    for i=1:N
        ii = push!(frust, frustation(g, σ, h, J, i))
        @assert ii == i # check handles
    end
    Emin = Inf
    for it=1:maxiters
        for _=1:N
            i = rand() < ϵ ? rand(1:N) : tophandle(frust)

            σ[i] *= -1
            frust[i] *= -1
            σi = σ[i]
            for (k,j) in enumerate(neighbors(g, i))
                frust[j] -= 2getJ(J,i,j,k) * σi * σ[j]
            end
        end
        if it % 10 == 0 && verb > 0
            E = energy(g,σ,h,J)/N
            Emin = E < Emin ? E : Emin
            println("it=$it ϵ=$ϵ m=",sum(σ)/N, " E=$E Emin=$Emin")
        end
        ϵ -= ϵstep
    end
    return σ
end

function frustation(g::AGraph, σ::Vector, h, J, i)
    H = h[i]
    for (k,j) in enumerate(neighbors(g, i))
        H += getJ(J, i, j, k) * σ[j]
    end
    return -H*σ[i]
end

Base.setindex!(h::MutableBinaryHeap, v, i::Int) = update!(h, i, v)
Base.getindex(h::MutableBinaryHeap, i::Int) = h.nodes[h.node_map[i]].value
tophandle(h::MutableBinaryHeap) = h.nodes[1].handle
