mutable struct Measure
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

function (&)(a::Measure, b::Measure)
	if a.error <= 0
        a.mean = b.mean
        a.error = b.error
        return
    end
    if b.error <= 0
        return
    end

    w1 = 1 / a.error^2
    w2 = 1 / b.error^2
    m = (a.mean * w1 + b.mean * w2 ) / (w1+w2)
    e = 1 / sqrt(w1+w2)
    return Measure(m, e)
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
