g = random_regular_graph(20, 3)
J = 100
h = rand(20)
σ, E = ground_state_mincut(g, h, J)
@test σ == ones(20)
σ, E = ground_state_mincut(g, -h, J)
@test σ == -ones(20)

J = Vector{Vector{Float64}}()
for i=1:nv(g)
    push!(J, zeros(degree(g, i)))
    for (k, j) in enumerate(neighbors(g, i))
        J[i][k] = rand()
    end
end

h = randn(20)
σ, E = ground_state_mincut(g, h, J)
σ2, E2 = ground_state_mincut(g, 2 + h, J)
@test all(σ .<= σ2)
