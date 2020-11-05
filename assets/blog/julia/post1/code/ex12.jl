# This file was generated, do not modify it. # hide
function getfunc2()
    counter::Int = 0
    function f()
        counter::Int += 1
        return counter
    end
end

func2 = getfunc2()

@btime $c()
@btime $func2()