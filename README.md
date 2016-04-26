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

The output of last line takes the form
```
# 1:a 2:b  3-4:sum  5-6:sum2
1.0 1.0  1.9475538619813686 0.0451499517325772  3.889147534300002 0.1107546140452498
2.0 2.0  3.993490144124805 0.045408591120803074  10.052396147374804 0.19432326686958687
3.0 3.0  6.029310940882452 0.04449860228513437  20.183505914408453 0.28023105772362356
4.0 4.0  7.967332069757028 0.044260556984930845  33.63136053874739 0.35865007774831204
5.0 5.0  9.988194927698062 0.04446817032948893  51.89725875233664 0.4479283636353768
6.0 6.0  11.988215043357055 0.046361361245179  73.93607623031374 0.5637565839623296
7.0 7.0  13.971520982049553 0.04606325507519284  99.67232060895837 0.6451967260589938
8.0 8.0  16.004420885279945 0.04521365300026202  130.0360273797746 0.7299609827209695
9.0 9.0  17.950020910225792 0.04520093327554878  163.1443633615597 0.8114722094137728
10.0 10.0  20.08347213915644 0.04356861490043347  203.57961128009254 0.878721667868061
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
