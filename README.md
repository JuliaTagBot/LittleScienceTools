# LittleScienceTools
Simple tools for everyday science and data analysis.
## Install
```julia
Pkg.clone("https://github.com/CarloLucibello/LittleScienceTools.git")
```

## module Measuring
Collecting averages over many samples and printing the results.
```julia
using LittleScienceTools.Measuring
```

### Observable
A type for computation of means and errors on means.
New observations can be taken using operator `&`.
Kahan summation algorithm is used.
```julia
nsamples = 10^6
ob = Observable()
for i=1:nsamples
    ob &= norm(2rand(2)-1) < 1 ? 1 : 0
end
ob *= 4
@assert isapprox(mean(ob), π, atol=5*error(ob))

println(ob) # print mean and its error : 3.140972 0.001642615473

ob = Observable()
vec = randn(nsamples)
for x in vec
    ob &= x
end
# or equivalently
#ob &= vec

error(ob) # ≈ std(vec) / √(nsamples-1)   
mean(ob) # ≈ mean(vec)
@assert isapprox(mean(ob), 0, atol=5*error(ob))
```
The `error` for a random variate of (theorical) standard deviation `σ` is approximately given by

```julia
error(obs) ~ σ / √nsamples
```

### ObsTable
A book-keeping structure for your `Observable`s.

```julia
type Params
    a; b
end

obs = ObsTable(Params)
# or as an equivalent alternative
obs = ObsTable()
set_params_names!(obs, [:a, :b])

for (x,y) in zip(1.:10., 1.:10.)
    par = Params(x,y)
    for i=1:1e3
        r1, r2 = [x,y] + randn(2)

        # Indexing can be done with a Tuple or with a type (which will be "splattered" to a tuple).
        # If there are no Observable corresponding to
        # a given name (i.e. :sum), a new one will be created.
        obs[par][:sum] &= r1 + r2
        obs[(x,y)][:sum2] &= r1^2 + r2^2
    end
end
open("res.dat","w") do f
    print(f, obs)
end
```

The output of last line looks like this:
```
# 1:a 2:b 3:nsamples  4-5:sum  6-7:sum2
1.0 1.0 1000  1.981 4.38e-02  3.864 1.05e-01
2.0 2.0 1000  3.972 4.41e-02  9.82 1.90e-01
3.0 3.0 1000  5.923 4.34e-02  19.448 2.67e-01
4.0 4.0 1000  8.025 4.36e-02  34.11 3.58e-01
5.0 5.0 1000  9.965 4.58e-02  51.71 4.64e-01
6.0 6.0 1000  11.871 4.57e-02  72.51 5.49e-01
7.0 7.0 1000  13.965 4.56e-02  99.54 6.45e-01
8.0 8.0 1000  16.019 4.58e-02  130.36 7.35e-01
9.0 9.0 1000  17.993 4.62e-02  163.91 8.38e-01
10.0 10.0 1000  20.016 4.60e-02  202.38 9.30e-01
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
Some custom vector types.
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
