include("../src/LittleScienceTools.jl")
using LittleScienceTools.Measuring
using Base.Test

nsamples=10^6
ob = Observable()
vec = randn(nsamples)
for x in vec
    ob &= x
end

@test isapprox(error(ob),  std(vec) / √(nsamples-1), atol=1e-9)
@test isapprox(mean(ob), sum_kbn(vec) / nsamples, atol=1e-14)
@test isapprox(mean(ob), 0, atol=5*error(ob))

ob = Observable()
for i=1:nsamples
    ob &= norm(2rand(2)-1) < 1 ? 1 : 0
end
ob *= 4
@test isapprox(mean(ob), π, atol = 5error(ob))


type Params
    a; b
end

obs = ObsTable(Params)
 # or as an equivalent alterntive
obs = ObsTable()
set_params_names!(obs, [:a, :b])
range = zip(1.:10., 1.:10.)
for (x,y) in range
    par = Params(x,y)
    for i=1:1e3
        r1, r2 = [x,y] + randn(2)
        obs[par][:sum] &= r1 + r2
        obs[par][:sum2] &= r1^2 + r2^2
    end
end

for (x,y) in range
    par = Params(x,y)
    @test obs[par] === obs[(x,y)]
    ob = obs[par][:sum]
    @test isapprox(mean(ob), x+y, atol=5error(ob))
end
print(obs)
