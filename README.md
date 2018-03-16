# LittleScienceTools
Simple tools for everyday science and data analysis with Julia. The package is divedd in different submodules:
- **Measuring**: keep averages and erros of observabls and print them in a nicely formatted way.
- **Ising**: find the ground state of Ising models, using minimum cut or heuristic algorithms.
- **Roots**: Newton and interpolation method for finding zeros of one- and multi-dimensional functions.

## Install
```julia
Pkg.clone("https://github.com/CarloLucibello/LittleScienceTools")
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
ob = Observable()
v = randn(nsamples)
for x in v
    ob &= x
end
# or equivalently
#ob &= v

error(ob) # error on the mean ≈ std(v) / √(nsamples-1)   
mean(ob) # ≈ mean(v)
@assert isapprox(mean(ob), 0, atol=5*error(ob))


ob = Observable()
for i=1:10^6
    ob &= norm(2rand(2)-1) < 1 ? 1 : 0
end
ob *= 4
@assert isapprox(mean(ob), π, atol=5*error(ob))

println(ob) # print mean and error
# 3.140972 0.001642615473
```
The `error` for a random variate with standard deviation `σ` is approximately given by

```julia
error(obs) ~ σ / √(nsamples-1)
```

### ObsTable
A book-keeping structure for your `Observable`s. Helpful
when measuring some observables under different sets of  
*external* parameters.

```julia
struct Params
    a; b
end

t = ObsTable(Params)
# or 
t = ObsTable()
set_params_names!(t, [:a, :b])
# or 
t = ObsTable(["a", "b"])

for (x,y) in zip(1.:10., 1.:10.)
    par = Params(x,y)
    for i=1:1000
        r1, r2 = [x,y] + randn(2)

        # ObsTable can be indexed in different ways
        t[x,y][:sum2] &= r1^2 + r2^2
        t[(x,y)][:sum2] &= r1^2 + r2^2
        t[[x,y]][:sum2] &= r1^2 + r2^2
        t[par][:sum] &= r1 + r2

        # If there are no Observable corresponding to
        # a given symbol (i.e. :sum), a new one will be created.
    end
end
open("res.dat","w") do f
    print(f, t)
end
```

The output of last line looks like this:
```
# 1:a    2:b      3:num    4:sum                6:sum2               
1.0      1.0      1000     1.986 4.58e-02       4.03 1.10e-01        
2.0      2.0      1000     4.006 4.45e-02       9.996 1.88e-01       
3.0      3.0      1000     5.964 4.44e-02       19.728 2.71e-01      
4.0      4.0      1000     7.976 4.44e-02       33.72 3.61e-01       
5.0      5.0      1000     9.937 4.41e-02       51.26 4.42e-01       
6.0      6.0      1000     11.998 4.39e-02      73.91 5.32e-01       
7.0      7.0      1000     14.038 4.31e-02      100.49 6.07e-01      
8.0      8.0      1000     16.066 4.64e-02      131.11 7.41e-01      
9.0      9.0      1000     17.958 4.37e-02      163.22 7.82e-01      
10.0     10.0     1000     20.037 4.57e-02      202.82 9.16e-01      
```
To store an ObsTable use JLD2:
```julia
using JLD2

@save "obs.jld2" t
@load "obs.jld2" t 
```
Multiple `ObsTable`s can me merged togheter in a single table:
```julia
t = merge(t1, t2, t3)
```

## module Ising
The package *Erdos.jl* is required for this:
```julia
Pkg.add("Erdos")
```
For models with ferromagneting couplings use `ground_state_mincut`to
find the ground state exactly:
```julia
using LittleScienceTools.Ising
using Erdos

g = random_regular_graph(20, 3)
J = 2 # costant couplings
h = randn(20)
σ, E = ground_state_mincut(g, h, J)

# couplings can also vary on each edge
J = sprand(20, 20, 0.1)
J -= Diagonal(J)
g = Graph(J)
σ, E = ground_state_mincut(g, h, J)
```
See `ground_state_τeo` for dealing with frustrated models.

## module Roots
Find roots with Newton's method or by interpolation.
```julia
using LittleScienceTools.Roots

ok, x, it, normf = findzero(x->(x^2-1)^2, 0.5) # default's to NewtonMethod
# x ≈ 1

ok, x, it, normf = findzero(x->[x[1]^2,x[2]^2], [1.,1.], NewtonMethod(), atol = 1e-13)
# x ≈ [0, 0]

ok, x, it, normf = findzero(x->exp(x)-1, 1, InterpolationMethod(), dx = 0.1)
# x ≈ 0
```
