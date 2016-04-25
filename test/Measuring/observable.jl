
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
