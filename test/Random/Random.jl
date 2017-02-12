# randperm
n = 100
r = [1:n;]
randperm!(r)
@test isperm(r)
@test r != [1:n;]

# randchoice
n = 10
r = [1:n;]
x = zeros(Int, 1000)
for i=1:length(x)
    x[i] = randchoice(r)
    @test 1 <= x[i] <= n
end
@test sort(union(x)) == r

a = randchoice(MersenneTwister(17),r)
@test 1 <= a <= n

r = (i for i in 1:20)
a = randchoice(r)
@test 1<= a <= 20

#getRNG
@test getRNG(-1) === Base.Random.GLOBAL_RNG
@test getRNG(0) === Base.Random.GLOBAL_RNG
@test getRNG(17) == MersenneTwister(17)

# randchoice!

s = randchoice(1:10, 3)
@test length(s) == 3
for  e in s
    @test 1 <= e <= 10
end


s = randchoice!([1:10;], 3)
@test length(s) == 3
for  e in s
    @test 1 <= e <= 10
end

s = randchoice!([1:10;], 6, exclude=[1,2])
@test length(s) == 6
for  e in s
    @test 3 <= e <= 10
end
