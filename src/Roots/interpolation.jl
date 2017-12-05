gplfile3 = joinpath(dirname(@__FILE__),"fit3.gpl")

"""
    type InterpolationMethod <: AbstractRootsMethod
        dx::Float64
        maxiters::Int
        parallel::Bool
        verb::Int
        atol::Float64
        n::Int
    end

Type containg the parameters for root finding through interpolation.
`n`: number of points to interpolate at each iteration. `dx`: points interspacing
for the first interpolation.
If `dx<0` the value `abs(x0)/20` shall be used.

The default parameters are:

    InterpolationMathod(dx=-1, maxiters=20, parallel= false, verb=0, atol=1e-10, n=6)

"""
mutable struct InterpolationMethod <: AbstractRootsMethod
    dx::Float64
    maxiters::Int
    parallel::Bool
    verb::Int
    atol::Float64
    n::Int
end

InterpolationMethod(; dx=-1, maxiters=20, parallel= false, verb=0, atol=1e-10, n=6) = 
                                    InterpolationMethod(dx, maxiters, parallel, verb, atol, n)

function findzero_interp(f::Function, x0::Float64, m::InterpolationMethod)
    dx = m.dx < 0 ? abs(x0)/20 : m.dx
    n = m.n
    s = x0
    ok = false
    iter = 1
    normf0 = Inf
    while !ok && iter <= m.maxiters
        m.verb > 3 && println("# TRIAL $iter for findzero_interp")
        xmax = s + 0.5*(n-1)*dx
        xmin  = s - 0.5*(n-1)*dx
        r = collect(linspace(xmin, xmax, n))
        if m.parallel
            refs = RemoteRef[]
            for i=1:length(r)
                push!(refs, @spawn f(r[i]))
            end

            f0 = [fetch(refs[i]) for i=1:length(r)]
        else
            f0 = [f(r[i]) for i=1:length(r)]
        end
        dummyfile, rf = mktemp()
        for i=1:length(r)
            println(rf, "$(r[i]) $(f0[i])")
        end
        close(rf)
        try
            s = float(readstring(`gnuplot -e "filename='$dummyfile'" -e "d=$s" $gplfile3`))
        catch
            error("ERROR GNUPLOT")
        end
        rm(dummyfile)

        normf0 = abs(f(s))
        if normf0 < m.atol
            m.verb > 3 && println("# SUCCESS x* = $(s), normf = $normf0")
            ok =true
        else
            m.verb > 1 && warn("failed: iter=$iter x* = $(s), normf = $normf0")
            ok =false
        end

        if !ok && f0[1]*f0[end] > 0
            dx *= 2
            m.verb > 3 && println("# dx=$dx")
        elseif !ok && f0[1]*f0[end] < 0
            dx /= 2
            m.verb > 3 && println("# dx=$dx")
        end
        iter += 1
    end
    return ok, s, iter, normf0
end
