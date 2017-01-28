"""
    interwine{T}(v1::Vector{T}, v2::Vector{T})

Interwine the elements of two vectors. The resulting
vector has double the length of the original ones.

**Example**
```
interwine([1,1,1], [2,2,2]) == [1,2,1,2,1,2]
```
"""
function interwine{T}(v1::Vector{T}, v2::Vector{T})
    @assert size(v1) == size(v2)
    v = Vector{T}(2length(v1))
    v[1:2:end] = v1
    v[2:2:end] = v2
    return v
end

"""
    interwine{T}(m1::Matrix{T}, m2::Matrix{T})

Interwine the columns of two matrices.
"""
function interwine{T}(m1::Matrix{T}, m2::Matrix{T})
    @assert size(m1) == size(m2)
    v = Vector{Vector{T}}(2size(m1,2))
    for j=1:size(m1,2)
        v[2j-1] = m1[:,j]
        v[2j] = m2[:,j]
    end
    return hcat(v...)
end
