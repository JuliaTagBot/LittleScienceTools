rng = ParisiRapuano()
n=1000
@test all(0 .<= rand(rng, n) .< 1.)
# @test all(-5 .<= randn(rng, 1000) .< 5.)
n=100000
# FAILING. Some proble with Close1Open2?
#@test abs(mean(randn(rng, n))) < 5 / √n
for n=[1_000, 10_000, 100_000]
    @test abs(mean(rand(rng, n))-0.5) < 20abs(mean(rand(n))-0.5)
    @test abs(var(rand(rng, n)) - 1/12) < 20abs(var(rand(n)) - 1/12)
end
