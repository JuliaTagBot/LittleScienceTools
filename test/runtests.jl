include("../src/LittleScienceTools.jl")
using LittleScienceTools.Measuring
using Base.Test

ob = Observable()
trials = 10^6
for i=1:trials
    ob &= norm(2rand(2)-1) < 1 ? 1 : 0
end
ob *= 4
@test isapprox(mean(ob), π, atol = 5error(ob))

ob = Observable()
for i=1:trials
    ob &= randn()
end
@test isapprox(mean(ob), 0, atol=5*error(ob))

type Params
    a; b
end

obs = ObsTable(Params)
 # or as an equivalent alterntive
obs = ObsTable()
set_params_names!(obs, [:a, :b])

for (x,y) in zip(1.:10., 1.:10.)
    par = Params(x,y)
    for i=1:1e3
        r1, r2 = [x,y] + randn(2)
        obs[par][:sum] &= r1 + r2
        obs[par][:sum2] &= r1^2 + r2^2
    end
end
print(obs)
