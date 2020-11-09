# This file was generated, do not modify it. # hide
function abmult2(r0::Int)
    r::Int = r0
    if r < 0
        r = -r
    end
    f = x -> x * r
    return f
end

mul2 = abmult2(-2)
@show mul2(2)
using InteractiveUtils
@code_warntype mul2(2)
