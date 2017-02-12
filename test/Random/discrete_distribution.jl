n = 1000
x = zeros(Int, n)
for i=1:n
    k = randint([0.1,0.1,0.8])
    x[i] = k
    @test 1 <= k <= 3
end
@test count(k->k==3, x) > n/2

for i=1:n
    k = randint([0.2,0.0,0.8])
    x[i] = k
    @test 1 <= k <= 3
    @test k != 2
end
