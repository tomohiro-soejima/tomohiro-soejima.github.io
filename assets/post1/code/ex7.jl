# This file was generated, do not modify it. # hide
f(x) = 2x
g(x) = 2x

function mysum(f, data)
    sum = zero(eltype(data))
    for a in data
        sum += f(a)
    end
end

data = rand(1000)
@time mysum(f, data) # includes compilation time
@time mysum(f, data) # after compilation
@time mysum(g, data) # compilation again