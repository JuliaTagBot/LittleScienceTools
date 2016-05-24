L = 10
v = ExtVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
extend_left!(v)
extend_right!(v)
for i=-2L:2L
    @test v[i] == 2i
end
@test length(v) == L
