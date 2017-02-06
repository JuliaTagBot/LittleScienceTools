gplfile3 = joinpath(dirname(@__FILE__),"fit3.gpl")

function findzero_interp(f::Function, x0::Float64;
                        dx::Float64 = abs(x0) / 20,
                        maxiters::Int = 20,
                        parallel::Bool = false,
                        verb::Int = 1,
                        atol::Float64 = 1e-10)
    s = x0
    ok = false
    iter = 1
    normf0 = Inf
    n = 5
    while !ok && iter <= maxiters
        verb > 3 && println("# TRIAL $iter for findzero_interp")
        xmax = s + 0.5*(n-1)*dx
        xmin  = s - 0.5*(n-1)*dx
        r = collect(linspace(xmin, xmax, n))
        if parallel
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
        if normf0 < atol
            verb > 3 && println("# SUCCESS x* = $(s), normf = $normf0")
            ok =true
        else
            verb > 1 && warn("failed: iter=$iter x* = $(s), normf = $normf0")
            ok =false
        end

        if !ok && f0[1]*f0[end] > 0
            dx *= 2
            verb > 3 && println("# dx=$dx")
        elseif !ok && f0[1]*f0[end] < 0
            dx /= 2
            verb > 3 && println("# dx=$dx")
        end
        iter += 1
    end
    return ok, s, iter, normf0
end
