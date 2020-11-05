# This file was generated, do not modify it. # hide
function mulsum0(r0::Int, data)
    f = x->x * r0
    return sum(f, data)
end

function abmulsum1(r0::Int, data)
    if r0 < 0
        r0 = -r0
    end
    f = let r0 = r0
        x->x * r0
        end
    return sum(f, data)
end

function abmulsum2(r0::Int, data)
    if r0 < 0
        r0 = -r0
    end
    f = x->x * r0
    return sum(f, data)
end

r0 = -2
data = rand(1000)

@btime mulsum0($r0, $data)
@btime abmulsum1($r0, $data)
@btime abmulsum2($r0, $data)