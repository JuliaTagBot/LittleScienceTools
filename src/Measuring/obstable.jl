typealias ObsData OrderedDict{Tuple,OrderedDict{Symbol,Observable}}

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
splat(a) = [a.(f) for f in fieldnames(a)]

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

# Iterable inteface
start(t::ObsTable) = start(t.data)
next(t::ObsTable, state)  = start(t.data)
done(t::ObsTable, state) = done(t.data)
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
    for k in onames
        print(io, " $i-$(i+1):$k ")
        i+=2
    end
    println(io)

    # PRINT DATA
    for (k, obs) in data
        for p in k
            print(io, "$p ")
        end
        for name in onames
            if haskey(obs, name)
                print(io, " $(obs[name])")
            else
                print(io, " NaN NaN ")
            end
        end
        println(io)
    end
end
