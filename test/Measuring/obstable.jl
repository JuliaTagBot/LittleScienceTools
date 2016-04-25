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
