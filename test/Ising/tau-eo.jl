srand(17)
N = 1000
z = 3
g =  random_regular_graph(N, z, seed=1)
Js = random_couplings(g)
σ, E = ground_state_τeo(g, Js, maxiters=10_000)
@test typeof(E) == Int
@test E == -1266
