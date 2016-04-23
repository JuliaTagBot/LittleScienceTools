module Measuring
using DataStructures

export Observable
export Measure
export add!, mean, var, error
export obs_from_mean_err_samp, measure_binomial
export ObsTable
export set_params_names!

import Base: &, +, *, error, mean, var
import Base: setindex!, getindex, start, done, next, endof, eltype, length

type Observable
    v1::Float64
    v2::Float64
    t::Int64

    # kahan reminders
    cv1::Float64
    cv2::Float64
end

Observable(v1, v2, t) = Observable(v1, v2, t, 0., 0.)
Observable() = Observable(0,0,0)

function obs_from_mean_err_samp(m, err, t)
    v1 = m*t
    var = err^2 *(t-1)
    v2 = (var + m^2)*t
    return Observable(v1, v2, t, 0., 0.)
end

function (&)(a::Observable,b::Observable)
    Observable(a.v1 + b.v1, a.v2 + b.v2, a.t + b.t)
end

# Kahan summation algorithm
function (&)(a::Observable,val::Number)
    y = val - a.cv1;
    z = a.v1 + y;
    cv1 = (z - a.v1) - y;
    v1 = z;

    y = val*val - a.cv2;
    z = a.v2 + y;
    cv1 = (z - a.v2) - y;
    v2 = z;

    vlast = val;
    t = a.t + 1;

    Observable(v1, v2, t)
end

mean(a::Observable) = a.t > 0 ? a.v1/a.t : 0
var(a::Observable) = a.v2 / a.t - mean(a)^2
error(a::Observable) = a.t > 1 ? sqrt(var(a) /(a.t -1)) : 0

function shortshow(io::IO, a::Observable)
    print(io, mean(a), " ", error(a))
end

Base.show(io::IO, a::Observable) = shortshow(io, a)

*(a::Observable, val::Number) = Observable(val*a.v1, val^2*a.v2, a.t, val*a.cv1, val*a.cv2)
*(val::Number, a::Observable) = *(a, val)

type Measure
    mean::Float64
    error::Float64
end

Measure() = Measure(0,-1)
Measure(a::Observable) = Measure(mean(a), error(a))
Measure(a::Measure) = Measure(a.mean, a.error)

function measure_binomial(nsucc::Integer, trials::Integer)
    p = nsucc /trials
    e = sqrt(p*(1-p) / trials)
    return Measure(p, e)
end

function add!(a::Measure, b::Measure)
	if a.error <= 0
        a.mean = b.mean
        a.error = b.error
        return
    end
    if b.error <= 0
        return
    end

    w1 = 1./ a.error^2
    w2 = 1./ b.error^2
    a.mean = (a.mean * w1 + b.mean * w2 ) / (w1+w2)
    a.error = 1. / sqrt(w1+w2)
end


function +(a::Measure, b::Measure)
	m = a.mean + b.mean
    e = sqrt(a.error^2 + b.error^2)
    Measure(m,e)
end

function *(a::Measure, b::Measure)
	m = a.mean*b.mean
    e = sqrt(b.mean^2*a.error^2 + a.mean^2*b.error^2)
    Measure(m,e)
end

+(a::Measure, val::Number) = a + Measure(val,0)

function *(a::Measure, val::Number)
	m = a.mean * val
    e = a.error * val
    Measure(m,e)
end

function shortshow(io::IO, a::Measure)
    print(io,a.mean, " ", a.error)
end

Base.show(io::IO, a::Measure) = shortshow(io, a)

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
        print(io, " $i:$k ")
        i+=2
    end
    println(io)

    # PRINT DATA
    for (k, v) in data
        for p in k
            print(io, "$p ")
        end
        for obs in values(v)
            print(io, " $obs ")
        end
        println(io)
    end
end
end #module
