# Knuth shuffles (see Wikipedia)
"""
    randperm!([rng,] v::AbstractArray)

In-place uniform random permutation of the elements of `v`.
"""
function randperm!(rng::AbstractRNG, v::AbstractArray)
    n = length(v)
    for i=1:n-1
        r = rand(rng, 0:n-i)
        v[i], v[i+r] = v[i+r], v[i]
    end
end

randperm!(v::AbstractArray) = randperm!(GLOBAL_RNG, v)
