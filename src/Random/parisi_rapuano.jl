# Ref [Parisi-Rapuano '85](http://www.sciencedirect.com/science/article/pii/0370269385906707)
type ParisiRapuano <: AbstractRNG
    myrand::UInt32
    ira::Array{UInt32,1}
    ip::UInt8
    ip1::UInt8
    ip2::UInt8
    ip3::UInt8
end

function ParisiRapuano(seed::Integer)
    seed = convert(UInt32, seed)
    myrand = seed;
    ip = 128;
    ip1 = ip - 24;
    ip2 = ip - 55;
    ip3 = ip - 61;
    ira = Array(UInt32, 256)
    y = UInt64(0)

    for i=ip3:ip-1
        y = myrand * 16807;
        myrand = (y & 0x7fffffff) + (y >> 31)
        if (myrand & 0x80000000) != 0
            myrand = (myrand & 0x7fffffff) + 1
        end
        ira[i+1] = myrand
    end
    return ParisiRapuano(myrand, ira, ip, ip1, ip2, ip3)
end

ParisiRapuano() = ParisiRapuano(make_seed()) # should be greater then 0

function make_seed()
    seed = UInt32(0)
    while seed == 0
        seed = rand(RandomDevice(), UInt32)
    end
    return seed
end

srand(r::ParisiRapuano, seed) = deepcopy!(r, ParisiRapuano(seed))

function deepcopy!{T}(dest::T, source::T)
    for name in fieldnames(T)
        setfield!(dest, name, deepcopy(getfield(source, name)))
    end
    return dest
end

function rand(r::ParisiRapuano, ::Type{Base.Random.CloseOpen})
    # assert( 1<= r.ip+1 <= 256)
	# assert( 1<= r.ip1+1 <= 256)
	# assert( 1<= r.ip2+1 <= 256)
	# assert( 1<= r.ip3+1 <= 256)
    uno = UInt8(1)
    x = (r.ira[r.ip1+1] + r.ira[r.ip2+1]) $ r.ira[r.ip3+1]
    r.ira[r.ip+1] = x
    r.ip = (r.ip + uno) % UInt8;
    r.ip1 = (r.ip1 + uno) % UInt8;
    r.ip2 = (r.ip2 + uno) % UInt8;
    r.ip3 = (r.ip3 + uno) % UInt8
    return 2.3283064365e-10 * x
end

rand(r::ParisiRapuano, ::Type{Base.Random.Close1Open2}) = rand(r, Base.Random.CloseOpen) + 1.
rand(r::ParisiRapuano, ::Type{Float64}) = rand(r, Base.Random.CloseOpen)
