# This file was generated, do not modify it. # hide
f(x) = 2x
h(x) = 2x
@show (typeof(f) == typeof(h))
@show f == h

f2 = x->2x
h2 = x->2x

@show(typeof(f2) == typeof(h2))
@show f2 == h2
