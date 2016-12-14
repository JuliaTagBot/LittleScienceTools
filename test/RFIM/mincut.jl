g = random_regular_graph(20, 3)
J = 1000
h = rand(20)
σ = rfim_ground_state(g, h, J)
@test σ == ones(20)
σ = rfim_ground_state(g, -h, J)
@test σ == -ones(20)
