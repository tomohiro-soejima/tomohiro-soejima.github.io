# This file was generated, do not modify it. # hide
function mygenmul(r0)
    if r0 < 0
        r0 = -r0
    end
    return (2r0*x for x in 1:10)
end

function mygenmul2(r0)
    if r0 < 0
        r0 = -r0
    end
    return let r0 = r0
        (2r0*x for x in 1:10)
    end
end

mygen1 = mygenmul(-2)
mygen2 = mygenmul2(-2)

@btime sum($mygen1)
@btime sum($mygen2);
