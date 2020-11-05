# This file was generated, do not modify it. # hide
f(x) = 2x
g(x) = 2x
@show (typeof(f) == typeof(g))
@show f == g

f2 = x->2x
g2 = x->2x

@show(typeof(f2) == typeof(g2))
@show f2 == g2