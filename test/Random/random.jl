n = 100
r = [1:n;]
randperm!(r)
@test isperm(r)
