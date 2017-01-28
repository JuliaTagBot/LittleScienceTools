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
