# This file was generated, do not modify it. # hide
function getfunc()
    count = 0
    function g()
        count += 1
        return count
    end
end

func = getfunc()
@show func()
@show func()
@show func()