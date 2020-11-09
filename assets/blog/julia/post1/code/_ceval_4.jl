# This file was generated, do not modify it. # hide
f2 = x->2x
f2 = x->3x # this redefinition happens without any problem
@show f2(2)
