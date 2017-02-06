# Newton 1d
ok, x, it, normf = findroot(x->2x, 1)
@test typeof(x) ==Float64
@test abs(x) < 1e-7
@test normf < 1e-13
@test ok
@test it < 4

ok, x, it, normf = findroot(x->x^2, 1)
@test abs(x) < 1e-5
@test normf < 1e-10
@test ok

ok, x, it, normf = findroot(x->(x^2-1)^2, 0.5)
@test abs(x-1) < 1e-5
@test normf < 1e-10
@test ok

ok, x, it, normf = findroot(x->(x^2-1)^2, 0.5, NewtonMethod(), atol=1e-14)
@test abs(x-1) < 1e-7
@test normf < 1e-14
@test ok

# Interpolation
ok, x, it, normf = findroot(x->2x, 1, InterpolationMethod())
@test typeof(x) ==Float64
@test abs(x) < 1e-7
@test normf < 1e-7
@test ok
@test it < 4

ok, x, it, normf = findroot(x->exp(x)-1, 0.1, InterpolationMethod())
@test abs(x) < 1e-7
@test normf < 1e-7
@test ok

# broken on Travis, gnuplot error
# ok, x, it, normf = findroot(x->exp(x)-1, 0.1, InterpolationMethod(), atol=1e-13)
# @test abs(x) < 1e-10
# @test normf < 1e-13
# @test ok

# Newton 2d
ok, x, it, normf = findroot(x->[x[1]^2,x[2]^2], [1.,1.])
@test length(x) == 2
@test norm(x) < 1e-4
@test normf < 1e-10
@test ok
