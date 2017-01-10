# 1d
ok, x, it, normf = newton(x->2x, 1)
@test typeof(x) ==Float64
@test abs(x) < 1e-7
@test normf < 1e-13
@test ok
@test it < 4

ok, x, it, normf = newton(x->x^2, 1)
@test abs(x) < 1e-7
@test normf < 1e-13
@test ok

ok, x, it, normf = newton(x->(x^2-1)^2, 0.5)
@test abs(x-1) < 1e-7
@test normf < 1e-13
@test ok

# 2d
ok, x, it, normf = newton(x->[x[1]^2,x[2]^2], [1.,1.])
@test length(x) == 2
@test norm(x) < 1e-7
@test normf < 1e-13
@test ok
