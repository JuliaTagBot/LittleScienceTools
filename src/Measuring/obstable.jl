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

function Base.show(io::IO, t::ObsTable)
    data = t.data; pnames= t.par_names
    onames = obs_names(t)
    ## PRINT HEADER
    print(io, "# ")
    i = 1
    for k in pnames
        print(io, "$i:$k ")
        i+=1
    end
    print(io, "$i:nsamples ")
    i+= 1
    for k in onames
        print(io, " $i-$(i+1):$k ")
        i+=2
    end
    println(io)

    # PRINT DATA
    for (par, obs) in data
        for p in par
            print(io, "$p ")
        end
        print(io, "$(nsamples(t, par)) ")
        for name in onames
            if haskey(obs, name)
                print(io, " $(obs[name]) ")
            else
                print(io, " NaN NaN ")
            end
        end
        println(io)
    end
end

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
