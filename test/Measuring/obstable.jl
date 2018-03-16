mutable struct Params
    a; b
end

@testset "obstable" begin
import DataStructures

t = ObsTable(Params)
 # or as an equivalent alternative
t2 = ObsTable()
set_params_names!(t2, ["a", "b"])
@test params_names(t2) == params_names(t)
@test t2 == ObsTable(["a","b"]) == ObsTable((:a,"b"))

t2 = ObsTable()
set_params_names!(t2, :a, :b)
@test t2.par_names == DataStructures.OrderedSet(["a","b"])

t2[1,2] #create entry
@test t2[1,2] === t2[(1,2)] === t2[[1,2]]

range = zip(1.:10., 1.:10.)
for (x,y) in range
    par = Params(x,y)
    for i=1:1e3
        r1, r2 = [x,y] + randn(2)
        t[par]["sum"] &= r1 + r2
        t[par]["sum2"] &= r1^2 + r2^2
        t[par][:sum3] &= r1 + r2
    end
    @test t[par][:sum] == t[par][:sum3]
end

for (x,y) in range
    par = Params(x,y)
    @test t[par] === t[(x,y)]
    ob = t[par]["sum"]
    @test isapprox(mean(ob), x+y, atol=5error(ob))
end
println(t)
open("test.dat","w") do f 
    print(f, t)
end
t2 = ObsTable("test.dat")
println(t2)

t1 = ObsTable(Params)
t2 = ObsTable(Params)
p = Params(1,2)
t1[p]["mag"] &= 5
t2[p]["mag"] &= 6
t = merge(t1,t2)
@test mean(t[p]["mag"]) == 5.5

t2[p]["ene"] &= 2
t = merge(t1,t2)
@test length(t.par_names) == 2
@test length(t.data) == 1
@test length(t[p]) == 2
@test mean(t[p]["ene"]) == 2

p2 = Params(2,3)
t2[p2]["ene"] &= 3
t = merge(t1,t2)									
@test length(t.par_names) == 2
@test length(t.data) == 2
@test length(t[p]) == 2
@test length(t[p2]) == 1
@test mean(t[p]["ene"]) == 2
@test mean(t[p2]["ene"]) == 3

@test mean(t[(p.a, p.b)][:ene]) == 2
@test mean(t[(p2.a, p2.b)][:ene]) == 3

println(t)

end #testset