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
    hmax = maximum(sum(abs, v), J)
    counter = zeros(Int, 2hmax + 1)
    for i=1:N
        f = frust
        idx = ftoidx(f, hmax)
        counter[idx] += 1
    end

    Emin = 10^6
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

ftoidx(f::Int, hmax::Int) = hmax -f + 1

function frust(g::AGraph, σ::Vector, J::Vector{Vector{Int}}, i)
    H = 0
    for (k,j) in enumerate(neighbors(g, i))
        H += J[i][k] * σ[j]
    end
    return H*σ[i]
end
