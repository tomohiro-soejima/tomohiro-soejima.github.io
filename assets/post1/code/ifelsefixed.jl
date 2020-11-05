# This file was generated, do not modify it. # hide
function get_q(condition)
    fun = if condition
        let
            q(::Int) = println("Cond was true")
            q(::Float64) = println("I don't like Float")
        end
    else
        let
            q(::Int) = println("I don't like Int")
            q(::Float64) = println("Cond was false")
        end
    end
    return fun
end

q = get_q(true)
q(1)
q(1.0)
q2 = get_q(false)
q2(1)
q2(1.0)