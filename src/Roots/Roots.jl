__precompile__()
module Roots
using Compat

export findroot, AbstractRootsMethod,
     NewtonMethod, InterpolationMethod

abstract type AbstractRootsMethod end

include("newton.jl")
include("interpolation.jl")


"""
    findroot(f, x₀, m=NewtonMethod())

Find a zero of `f` starting from the point `x₀`.

Available algorithms are `NewtonMethod` and  `InterpolationMethod` (necessitates `gnuplot`).

The derivative of `f` is computed by numerical discretization. Multivariate
functions are supported by `NewtonMethod`.


Returns a tuple `(ok, x, it, normf)`.

**Usage Example**
```
ok, x, it, normf = findroot(x->exp(x)-x^4, 1., NewtonMethod(atol=1e-5))
```
"""
findroot(f, x0) = findroot(f, x0, NewtonMethod())
findroot(f, x0::Real, m::AbstractRootsMethod) = findroot(f, Float64(x0), m)
findroot(f, x0::Float64, m::NewtonMethod) = newton(f, x0, m)
findroot(f, x0::Vector{Float64}, m::NewtonMethod) = newton(f, x0, m)
findroot(f, x0::Float64, m::InterpolationMethod) = findzero_interp(f, x0, m)

end #module
