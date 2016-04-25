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

srand(r::ParisiRapuano, seed) = deepcopy!(r, ParisiRapuano(seed))

function deepcopy!{T}(dest::T, source::T)
    for name in fieldnames(T)
        setfield!(dest, name, deepcopy(getfield(source, name)))
    end
    return dest
end

function rand(r::ParisiRapuano, ::Type{Base.Random.CloseOpen})
    assert( 1<= r.ip+1 <= 256)
	assert( 1<= r.ip1+1 <= 256)
	assert( 1<= r.ip2+1 <= 256)
	assert( 1<= r.ip3+1 <= 256)
    r.ira[r.ip+1] = (r.ira[r.ip1+1] + r.ira[r.ip2+1]) $ r.ira[r.ip3+1]
    x = r.ira[r.ip+1]
    r.ip+=1; r.ip1+=1;r.ip2+=1; r.ip3+=1
    return 2.3283064365e-10 * x
end

rand(r::ParisiRapuano, ::Type{Base.Random.Close1Open2}) = rand(r, Base.Random.CloseOpen) + 1.


end
