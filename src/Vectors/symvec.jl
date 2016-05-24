"""
    type SymVec{T}
        v::Vector{T}
        L::Int
    end

A vector type for symmetric indexing. Indexing is allowed in the range -L:L.

*Example*
```julia
L = 10
v = SymVec{Int}(L)
for i=-L:L
    v[i] = 2i
end
for i=-L:L
    @assert v[i] == 2i
end
v[L+1] # Error
v[-L-1] # Error
```
"""
type SymVec{T}
    v::Vector{T}
    L::Int
end

function SymVec{T}(v::Vector{T})
    @assert isodd(length(v))
    L = (length(v) - 1) ÷ 2
    SymVec(v, L)
end

convert{T}(::Type{SymVec{T}}, L::Integer = 0) = SymVec(Array(T, 2L+1), L)
length(v::SymVec) = v.L
# eltype(v::SymVec) = eltype(v.v)
@inline setindex!(v::SymVec, x, i) = setindex!(v.v, x, v.L+1+i)
@inline getindex(v::SymVec, i) = getindex(v.v, v.L+1+i)
