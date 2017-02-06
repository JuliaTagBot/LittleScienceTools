__precompile__()
module Roots
export findroot, AbstractRootsMethod,
     NewtonMethod, InterpolationMethod

include("newton.jl")
include("interpolation.jl")

abstract AbstractRootsMethod
immutable NewtonMethod <: AbstractRootsMethod end
immutable InterpolationMethod <: AbstractRootsMethod end


"""
    findroot(f, x₀, m=NewtonMethod(); kws...)

Find a zero of `f` starting from the point `x₀`.

Available algorithms are `NewtonMethod()` and  `InterpolationMethod()` (necessitate `gnuplot`).

The derivative of `f` is computed by numerical discretization. Multivariate
functions are supported by `NewtonMethod()`.

Returns a tuple `(ok, x, it, normf)`.

**Usage Example**
ok, x, it, normf = findroot(x->exp(x)-x^4, 1.)
ok || normf < 1e-10 || warn("Newton Failed")

"""
findroot(f, x0; kws...) = findroot(f, x0, NewtonMethod(); kws...)

findroot(f, x0::Real, m::AbstractRootsMethod; kws...) = findroot(f, Float64(x0), m; kws...)
findroot(f, x0::Float64, ::NewtonMethod; kws...) = newton(f, x0; kws...)
findroot(f, x0::Vector{Float64}, ::NewtonMethod; kws...) = newton(f, x0; kws...)
findroot(f, x0::Float64, ::InterpolationMethod; kws...) = findzero_interp(f, x0; kws...)

end #module
