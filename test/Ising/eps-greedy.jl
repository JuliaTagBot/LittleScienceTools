srand(17)
n = 100
h = fill(-1,n)
J = sprand(n, n, 0.1)
J -= Diagonal(J)
g = Graph(J)
σ = ground_state_ϵgreedy(g, h, J; ϵ=0.1, maxiters=100, verb=1)
@test sum(σ) < 0

n = 100
h = zeros(n)
J = sprandn(n, n, 0.1)
J -= Diagonal(J)
g = Graph(J)
σ = ground_state_ϵgreedy(g, h, J; ϵ=0.5, maxiters=1000, verb=1, ϵstep=-1.)
@test sum(σ) < 0
