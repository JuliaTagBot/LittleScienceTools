```

## module Random
Random number generation related utilities.
```julia
using LittleScienceTools.Random
```
### ParisiRapuano (Experimental)
A pseudo-random number generator based on Ref [Parisi-Rapuano '85](http://www.sciencedirect.com/science/article/pii/0370269385906707)
This variant of linear congruential engine should be much faster then julia's standard MersenneTwister.
(TODO BENCHMARKS)
```julia
type ParisiRapuano <: AbstractRNG
    ....
end
```
It conforms to the julia abstract RNG interface (which is not documented at all):
```julia
rng = ParisiRapuano()
srand(rng, 17)
# or equivalently
rng = ParisiRapuano(17)

r = rand(rng)   # 0 <= r < 1.
v = rand(rng, 100)   # 100  random floats uniform in [0,1)

# ATTENTION: don't use randn, has issues!
# v = randn(rng, 10) # 10 normally distributed floats
```

### randperm!
```julia
"""
    randperm!([rng,] v::AbstractArray)

In-place uniform random permutation of the elements of `v`.
"""
```

## module Vectors
**DO NOT USE, NOT PERFORMANT** Some custom vector types.
```julia
using LittleScienceTools.Vectors
```
### SymVec
```julia
type SymVec{T}
    v::Vector{T}
    L::Int
end
```
A vector type for symmetric indexing. Indexing is allowed in the range -L:L.

*Example*
```julia
L = 10
v = SymVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
for i=-L:L
    @assert v[i] == 2i
end
v[L+1] # Error
v[-L-1] # Error
```

### ExtVec
```julia
type ExtVec{T}
    v::SymVec{T}
    L::Int
    a_left::T
    b_left::T
    a_right::T
    b_right::T
end
```

A extended vector type for symmetric indexing and linear extrapolation outside
its boundaries.
*Example*
```julia
L = 10
v = ExtVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
extend_left!(v)
extend_right!(v)
for i=-3L:3L
    @assert v[i] == 2i
end
```
