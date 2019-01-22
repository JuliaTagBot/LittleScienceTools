@testset "observable" begin

nsamples=10^6
ob = Observable()
v = randn(nsamples)
for x in v
    ob &= x
end

@test isapprox(err(ob),  std(v) / √(nsamples-1), atol=1e-9)
@test isapprox(mean(ob), sum_kbn(v) / nsamples, atol=1e-14)
@test isapprox(mean(ob), 0, atol=5*err(ob))

ob = Observable()
for i=1:nsamples
    ob &= norm(2 .* rand(2) .- 1) < 1 ? 1 : 0
end
ob *= 4
@test isapprox(mean(ob), π, atol = 5err(ob))

@test ob == ob

ob2 = copy(ob)
ob2 &= NaN
@test ob2 == ob
ob2 &= Inf
@test ob2 == ob

end #testset