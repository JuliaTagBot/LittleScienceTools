# randint
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
    @test 1 <= k <= 3
    @test k != 2
end

for i=1:n
    k = randint([1.0,0.0,0.])
    @test k == 1
end

@test 0 == randint([0.0,0.0,0.])

# DiscreteDistribution
n = 1000
x = zeros(Int, n)
d = DiscreteDistribution([0.1,0.1,0.8])
for i=1:n
    k = rand(d)
    x[i] = k
    @test 1 <= k <= 3
end
@test count(k->k==3, x) > n/2

d = DiscreteDistribution([0.2,0.,0.8])
for i=1:n
    k = rand(d)
    @test 1 <= k <= 3
    @test k != 2
end

d = DiscreteDistribution([1.0,0.0,0.])
for i=1:n
    k = rand(d)
    @test k == 1
end
