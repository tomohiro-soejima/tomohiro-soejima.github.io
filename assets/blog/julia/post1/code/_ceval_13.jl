# This file was generated, do not modify it. # hide
c = Closure(0)
func = getfunc()

using BenchmarkTools
@btime $c()
@btime $func();
