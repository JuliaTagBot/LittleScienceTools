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
