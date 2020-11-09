# This file was generated, do not modify it. # hide
function abmult3(r0::Int)
    r::Int = r0
    if r < 0
        r = -r
    end
    f = let r2 = r
        x -> x * r2
        end
    return f
end

mul3 = abmult3(-2)
@show mul3(2)
@code_warntype mul3(2)
