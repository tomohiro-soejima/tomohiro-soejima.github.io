# This file was generated, do not modify it. # hide
function get_q(condition)
    if condition
        q(::Int) = println("Cond was true")
        q(::Float64) = println("I don't like Float")
    else
        q(::Int) = println("I don't like Int")
        q(::Float64) = println("Cond was false")
    end
    return q
end

q = get_q(true)
q(1)
q(1.0)
q = get_q(false)