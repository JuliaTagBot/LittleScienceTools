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
    return Observable(v1, v2, t)
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
    cv2 = (z - a.v2) - y;
    v2 = z;

    vlast = val;
    t = a.t + 1;

    Observable(v1, v2, t)
end

function (&)(a::Observable,vals::AbstractArray)
     b = deepcopy(a)
    for x in vals
        b &= x
    end
    return b
end


mean(a::Observable) = a.t > 0 ? a.v1/a.t : 0
var(a::Observable) = a.v2 / a.t - mean(a)^2
error(a::Observable) = a.t <= 1 ? 0 :
                       var(a) < 0 ? 0. : sqrt(var(a) /(a.t -1)) # sometimes numerical errors for small var

function shortshow(io::IO, a::Observable)
    max_round = 10
    if error(a) > 0.
        r = round(Int, log(10, error(a))) - 2
        r = abs(min(0,r))
        r = min(r, max_round)
        # const fmt = "%.$(r)f %.2e"
        # @eval @printf($io, $fmt, $(mean(a)), $(error(a)))#mean(a), " ", error(a))
        print(io, "$(round(mean(a),r)) ")
        @printf(io, "%.2e", error(a))
    else
        print(io, "$(round(mean(a), max_round)) $(error(a))")
    end
end

Base.show(io::IO, a::Observable) = shortshow(io, a)

*(a::Observable, val::Number) = Observable(val*a.v1, val^2*a.v2, a.t)
*(val::Number, a::Observable) = *(a, val)

+(a::Observable, val::Number) = Observable(a.v1 + val*a.t, a.v2 + val*a.v1 + val^2*a.t, a.t)
+(val::Number, a::Observable) = +(a, val)

"""
Desidered properties for `t` of obs resulting from composition of Observables `a` and `b`:

1. symmetric in `a` and `b`
2. error(a) -> 0  =>  t ~ b.t
2. error(a) >> error(b)  =>  t ~ a.t
3. a.t -> ∞  =>  t = b.t
4. a == b  => t = a.t = b.t

One possible choice is `t ≃ (error(a) + error(b)) / (error(a)/a.t + error(b)/b.t)`
"""
function t_composition(a::Observable, b::Observable)
    ea, eb = error(a), error(b)
    return ceil(Int, (ea + eb)/(ea/a.t + eb/b.t))
end

function +(a::Observable, b::Observable)
    t = t_composition(a, b)
    ea, eb = error(a), error(b)
    ma, mb = mean(a), mean(b)
    e = sqrt(ea^2 + eb^2)
    v1 = (ma + mb) * t
    v2 = e^2*t + v1^2/t
    Observable(v1, v2, t)
end

function *(a::Observable, b::Observable)
    t = t_composition(a, b)
    ma, mb = mean(a), mean(b)
    ea, eb = error(a), error(b)
    e = sqrt(mb^2*ea^2 + ma^2*eb^2)
    v1 = ma*mb*t
    v2 = e^2*t + v1^2/t
    Observable(v1, v2, t)
end
