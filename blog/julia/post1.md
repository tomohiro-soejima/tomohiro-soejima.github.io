@def title = "Function like objects and closures"
@def hascode = true
@def published = Date(2020, 11, 5)
@def rss = "Function-like objects in Julia"
@def author="Tomohiro Soejima"

@def tags = ["syntax", "code"]


Functions are "first-class citizens" in julia. Accordingly, there are a lot of neat tricks you can play with functions such as function closures. On the other hand, there are some pitfalls when using functions that were not obvious to me at first sight. This post is an attempt to document and clarify how functions behave.


@def maxtoclevel=3
\toc

## Julia functions

### Julia functions are first-class citizens

You can define a **named** function and assign that to a variable.

```!
f(x) = 2x
g = f

g # show this
```

We can also define **anonymous** functions via `x->f(x)` syntax:

```!
f2 = x->2x
g2 = f2
g2 # show this
```

Note that anonymous functions are labeled by some number (e.g. #1) instead of its name.

Named functions behave kind of like constants, in the sense it cannot be reassigned.

```!
f(x) = 2x
f = x->3x # invalid redefinition of constant f
```

Meanwhile, variables that were assigned anonymous functions can be reassigned with no problem

```!
f2 = x->2x
f2 = x->3x # this redefinition happens without any problem
@show f2(2)
```

#### Function definition inside if-else block

Because of this `const`-like nature of functions, there are some pitfalls you might encounter. Consider the following example:

```!
function get_q(condition)
    if condition
        q(::Int) = println("Cond was true")
        q(::Float64) = println("I don't like Float")
    else
        q(::Int) = println("I don't like Int")
        q(::Float64) = println("Cond was false")
    end
    return q
end

q = get_q(true)
q(1)
q(1.0)
q = get_q(false)
```

We immediately see two issues. 1. `q` returns the results for `condition == false`, even though we passed `condition == true`. 2. When we pass `condition==false`, the code faces and `UndefVarError`. This seems to come from how Julia parser works: The parser parses function definitions in a given local scope without regarding the control flow, so it makes the later appearance the definition of `q`.

A clean way to get around this problem is to use let blocks to introduce new local scopes:

```!
function get_q(condition)
    fun = if condition
        let
            q(::Int) = println("Cond was true")
            q(::Float64) = println("I don't like Float")
        end
    else
        let
            q(::Int) = println("I don't like Int")
            q(::Float64) = println("Cond was false")
        end
    end
    return fun
end

q = get_q(true)
q(1)
q(1.0)
q2 = get_q(false)
q2(1)
q2(1.0)
```

### Julia functions are their own types

There are functions that take other functions as argument. These so-called **higher-order functions** are very useful in Julia. A simple example is a `sum` function:

```!
f(x) = 2x
@show sum(f, 1:10)
```

In order for this `sum` to be fast, you want it to specialize to the particular function `f` you passed. In order to allow this, every function is its own type such that Julia's type system can take care of code specialization (where is this in the documentation?). In particular, this means two functions with the same definition have different types, and are thus different objects.

```!
f(x) = 2x
h(x) = 2x
@show (typeof(f) == typeof(h))
@show f == h

f2 = x->2x
h2 = x->2x

@show(typeof(f2) == typeof(h2))
@show f2 == h2
```

A straightforward consequence of this is that compiling a function with `f` does not compile it for `g`.

```!
f(x) = 2x
h(x) = 2x

function mysum(f, data)
    sum = zero(eltype(data))
    for a in data
        sum += f(a)
    end
end

data = rand(1000)
@time mysum(f, data) # includes compilation time
@time mysum(f, data) # after compilation
@time mysum(h, data) # compilation again
```

## Function-like objects

### Defining callable type
Julia has objects other than functions that behave like one. These are called **function-like objects**. Here is an example straight out of the julia [manual](https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects).

```!
struct Polynomial{R}
    coeffs::Vector{R}
end

function (p::Polynomial)(x)
    v = p.coeffs[end]
    for i = (length(p.coeffs)-1):-1:1
        v = v*x + p.coeffs[i]
    end
    return v
end

p = Polynomial([1, 10, 100])
@show p(5)
```

In other words, function-like objects can be thought of as functions that carry extra data. This gives us access to closures.

### Closures
Closures are functions that can reference its own environment. It is usually defined inside another function. Here is a simple example.

```!
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
```

Here, the function `func` carries around the variable `const`, and it increments it every time the function is called. The closure behaves very similarly to the following function-like object:

```!
mutable struct Closure
    counter :: Int
end

function (c::Closure)()
    c.counter += 1
    return c.counter
end

c = Closure(0)
@show c()
@show c()
@show c()
```

In other words, a closure is a function with extra (potentially mutable) data.


### Not all closures are created equal
There's a performance caveat regarding the use of closures. We first test `@code_warntype` of `func()`.

```julia
@code_warntype func()
```

Output:
```julia
Variables
  #self#::f.var"#g#27"
  count@_2::Union{}
  count@_3::Union{}

Body::ANY
1 ─ %1  = Core.getfield(#self#, :count)::CORE.BOX
│   %2  = Core.isdefined(%1, :contents)::Bool
└──       goto #3 if not %2
2 ─       goto #4
3 ─       Core.NewvarNode(:(count@_2))
└──       count@_2
4 ┄ %7  = Core.getfield(%1, :contents)::ANY
│   %8  = (%7 + 1)::ANY
│   %9  = Core.getfield(#self#, :count)::CORE.BOX
│         Core.setfield!(%9, :contents, %8)
│   %11 = Core.getfield(#self#, :count)::CORE.BOX
│   %12 = Core.isdefined(%11, :contents)::Bool
└──       goto #6 if not %12
5 ─       goto #7
6 ─       Core.NewvarNode(:(count@_3))
└──       count@_3
7 ┄ %17 = Core.getfield(%11, :contents)::ANY
└──       return %17
```

It is screaming type instability (see `Body::Any`) because the compiler cannot figure out `counter` only takes on integer values (It is in fact put inside a `Core.Box`, a julia type for handling variables with unknown value). As a result, this particular closure is a lot slower than a similar looking function-like object. 


```!
c = Closure(0)
func = getfunc()

using BenchmarkTools
@btime $c()
@btime $func();
```

Type annotation somewhat helps, but it is not enough to eliminate the performance gap.

```!
function getfunc2()
    counter::Int = 0
    function f()
        counter::Int += 1
        return counter
    end
end

func2 = getfunc2()

@btime $c()
@btime $func2();
```

### Closure and let blocks
Part of the problem in the previous section was the appearance of `Core.box` in type inference. In some cases, we can eliminate such ambiguity via clever use of `let...end` blocks.

Let's look at an [example](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured) from the Julia manual.

```!
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
```


We again see the dreaded `Core.box`. The reason is the value of `r` can, in theory, be changed, and Julia needs to keep track of that fact by putting `r` in a box. However, when we return something like this, we actually want to return a function with a fixed `r`. We can do that using a `let...end` block.

```!
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
```

`let...end` introduces a new local scope. Inside the local scope, a new variable  `r2` is bound to the value of `r` at the time of evaluation. Since `r2` goes out of scope, Julia compiler is able to remove `Core.box`.

Removing `Core.box` comes with a great performance benefit. In fact, the resultin function `mul3` is almost as performant as a similar top level function.

```!
mul0 = x->2x

@btime $mul0(2)
@btime $mul2(2)
@btime $mul3(2);
```


Note that such care is necessary even if the closure is only used inside the function itself.

```!
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
@btime abmulsum2($r0, $data);
```

### Miscallaneous anonymous function appearances
There are other places where anonymous functions are useful. One prominent example is generators.

```julia
mygen = (2x for x in 1:10)
```

This `2x` here is really an anonymous function. To make it explicit, we can instead write

```julia
mygen2 = Base.Generator(x->2x, 1:10)
```

Since generator carries an anonymous function, performance concerns about captured variables also applie to them. Consider the following functions:

```!
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
```

The second function is markedely faster than the first one, precisely because of the issue with captured variables.

## Summary and performance tips

There are many different ways of defining function-like objects in julia, which lets the function carry some external data. When used correctly, these objects help us write powerful and performant Julia code. On the other hand, there are somewhat subtle performance pitfalls that one needs to be aware of. Here is a short summary of what to do in different scenarios.

1. If you want to change the binding of the data (e.g. [the `counter` example](#closures), where `Closure.counter` needed to be updated), callable `mutable struct` is your best bet.
2. If you want to modify the data from outside of the function, callable `struct` is the way to go, since you can easily access the data via `object.data`.
3. If you don't need to directly access the data, and you don't need to change the binding, normal closure does the job. However, [be careful](https://docs.julialang.org/en/v1/manual/performance-tips/#man-performance-captured) with captured variables, and [use `let...end` blocks](#closure-and-let-blocks) as appropriate.

I hope that was useful, and please feel free to send me some comments!


