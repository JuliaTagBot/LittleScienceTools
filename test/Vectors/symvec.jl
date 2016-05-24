L = 10
v = SymVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
for i=-L:L
    @test v[i] == 2i
end
# @test_throws(v[L+1], BoundsError)
# @test_throws(v[-L-1], BoundsError)
