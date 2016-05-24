"""
    type ExtVec{T}
        v::SymVec{T}
        L::Int
        a_left::T
        b_left::T
        a_right::T
        b_right::T
    end

A extended vector type for symmetric indexing and linear extrapolation outside
its boundaries.

*Example*
```julia
L = 10
v = ExtVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
extend_left!(v)
extend_right!(v)
for i=-3L:3L
    @assert v[i] == 2i
end
```
"""
type ExtVec{T}
    v::SymVec{T}
    L::Int
    a_left::T
    b_left::T
    a_right::T
    b_right::T
end
convert{T}(::Type{ExtVec{T}}, L::Integer = 0) = ExtVec(SymVec{T}(L), L
                                    , zero(T), zero(T), zero(T), zero(T))

length(v::ExtVec) = length(v.v)
# eltype(v::ExtVec) = eltype(v.v)
@inline setindex!(v::ExtVec, x, i) = setindex!(v.v, x, i)
@inline getindex(v::ExtVec, i) = i < -v.L ? v.a_left + v.b_left*i :
                         i > v.L ? v.a_right+v.b_right*i : getindex(v.v, i)

function extend_left!(v::ExtVec)
    L=v.L
    a=v[-L+1]-v[-L]
    b= v[-L]+L*a
    extend_left!(v, b, a)
end
function extend_right!(v::ExtVec)
    L = v.L
    a = v[L]-v[L-1]
    b = v[L]-L*a
    extend_right!(v, b, a)
end
extend_left!(v::ExtVec, a, b) = (v.a_left=a; v.b_left=b)
extend_right!(v::ExtVec, a, b) = (v.a_right=a; v.b_right=b)
