# This file was generated, do not modify it. # hide
mutable struct Closure
    counter :: Int
end

function (c::Closure)()
    c.counter += 1
    return c.counter
end

c = Closure(0)
@show c()
@show c()
@show c()