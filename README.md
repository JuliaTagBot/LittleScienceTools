# LittleScienceTools
Some useful tools for everyday science and data analysis.

## Measuring
```julia
using LittleScienceTools.Measuring
```

### Observable
A type computing means and errors on means.
New measurements can be taken using operator `&`.
Kahan summation algorithm is used.
```julia
ob = Observable()
for i=1:10^6
    ob &= norm(2rand(2)-1) < 1 ? 1 : 0
end
ob *= 4
@assert isapprox(mean(ob), π, atol=5*error(ob))

println(ob) # prin mean and error : 3.140972 0.001642615473

ob = Observable()
for i=1:10^6
    ob &= randn()
end
@assert isapprox(mean(ob), 0, atol=5*error(ob))
```
### ObsTable
