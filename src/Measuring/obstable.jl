typealias Ord Base.Order.ForwardOrdering
typealias ObsData SortedDict{Tuple,OrderedDict{Symbol,Observable}, Ord}

type ObsTable
    data::ObsData
    par_names::OrderedSet{Symbol}
end

ObsTable() = ObsTable(ObsData(), OrderedSet{Symbol}())
function ObsTable{Params}(::Type{Params})
    t = ObsTable()
    set_params_names!(t, fieldnames(Params))
    t
end
ObsTable{T}(params::T) = ObsTable(T)

splat(a) = [getfield(a,f) for f in fieldnames(a)]

#set_params_names!(t::ObsTable, a) = set_params_names!(fieldnames(a))
function set_params_names!(t::ObsTable, keys::Vector{Symbol})
    length(t.par_names) != 0 && Error("Can be done only once!")
    t.par_names = OrderedSet(keys)
end

params_names(t::ObsTable) = t.par_names

function obs_names(t::ObsTable)
    names = OrderedSet{Symbol}()
    for (k,v) in t.data
        push!(names, keys(v)...)
    end
    names
end

function nsamples(t::ObsTable, par::Tuple)
    haskey(t, par) || return 0
    return first(t[par])[2].t
end

# Indexing inteface
getindex(t::ObsTable, i) = get!(t.data, to_index(i), OrderedDict{Symbol,Observable}())
setindex!(t::ObsTable, v, i) = setindex!(t.data, v, to_index(i))
getindex(d::OrderedDict{Symbol,Observable}, i::Symbol) = get!(d, i, Observable())
function to_index(i)
    if length(fieldnames(i)) == 0
        return (i,)
    else
        return (splat(i)...)
    end
end
to_index(i::Tuple) = i

endof(t::ObsTable) = endof(t.data)

haskey(t::ObsTable, k) = haskey(t.data, k)

# Iterable inteface
start(t::ObsTable) = start(t.data)
next(t::ObsTable, state)  = next(t.data, state)
done(t::ObsTable, state) = done(t.data, state)
eltype(::Type{ObsTable}) = eltype(typeof(t.data))
length(t::ObsTable) = length(t.data)

"""
    header(t::ObsTable)

Returns a string containg the header of the printed table.
"""
function header(t::ObsTable; lenpar=9, lenobs=18)
    pnames= t.par_names
    onames = obs_names(t)
    h = ""
    i = 1
    for k in pnames
        s = i == 1 ? "# $i:$k": "$i:$k"
        h *= s * repeat(" ",lenpar-length(s))
        i+=1
    end
    s = "$i:num"
    h *= s * repeat(" ",lenpar-length(s))
    i+= 1
    for k in onames
        s = "$i:$k"
        h *=  s * repeat(" ",lenobs-length(s))
        i+=2
    end
    return strip(h)
end

function Base.show(io::IO, t::ObsTable)
    lenpar = 9
    lenobs = 21
    println(io, header(t, lenpar=lenpar, lenobs=lenobs))

    for (par, obs) in t
        for p in par
            s = "$p"
            print(io, s * repeat(" ", lenpar-length(s)))
        end
        s = "$(nsamples(t, par))"
        print(io, s * repeat(" ", lenpar-length(s)))
        for name in obs_names(t)
            s = haskey(obs, name) ? "$(obs[name])" : "NaN NaN"
            print(io, s * repeat(" ", lenobs-length(s)))
        end
        println(io)
    end
end

"""
    merge(t1::ObsTable, t2::ObsTable)

Fuse togheter the observations of `t1` and `t2`.
"""
function merge(t1::ObsTable, t2::ObsTable)
    t = deepcopy(t1)
    return merge!(t, t2)
end

function merge!(t::ObsTable, t2::ObsTable)
    t.par_names = union(t.par_names, t2.par_names)
    for (k,v) in t2
        for (n, o) in v
            t[k][n] &= o
        end
    end
    return t
end

"""
    tomatrices(t::ObsTable) -> (params, means, errors)

Converts `t` into three matrices, `params`,`means` and `errors`.
"""
function tomatrices(t::ObsTable)
    n = length(t)
    m1 = length(params_names(t))
    pars = zeros(n,m1)
    onames = obs_names(t)
    m2 = length(obs_names(t))
    y = zeros(n, m2)
    yerr = zeros(n, m2)
    i = 1
    for (p, olist) in t
        pars[i,:] = [p...]
        for (j, oname) in enumerate(onames)
            obs = olist[oname]
            y[i,j] = mean(obs)
            yerr[i,j] = error(obs)
        end
        i += 1
    end
    return pars, y, yerr
end


"""
    tomatrix(t::ObsTable)

Converts `t` into a matrix corresponding to the printed table.
See [`header`](@ref) for the meaning of the columns.
"""
function tomatrix(t::ObsTable)
    n = length(t)
    m1 = length(params_names(t))
    onames = obs_names(t)
    m2 = length(obs_names(t))
    y = zeros(n, m1 + 1 + 2m2) #condidering also #samples
    i = 1
    for (p, olist) in t
        y[i,1:m1] = [p...]
        y[i,m1+1] = nsamples(t, p)
        for (j, oname) in enumerate(onames)
            obs = olist[oname]
            j = 2j+m1
            y[i,j] = mean(obs)
            y[i,j+1] = error(obs)
        end
        i += 1
    end
    return y
end
