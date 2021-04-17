@def title = "Quick guide to Julia"
@def hascode = true
@def published = Date(2021, 4,17)
@def rss = "Quick guide to julia"
@def author="Tomohiro Soejima"

@def tags = ["syntax", "code"]


Learning how to write Julia is relatively easy. As a dynamic language focused on numerical computation, it's syntax is relatively straightforward. There are good cheatsheets to get you started such as [this comparison with Python and Matlab](https://cheatsheets.quantecon.org/) or [this general purpose cheat sheet](https://juliadocs.github.io/Julia-Cheat-Sheet/). What may be harder is to figure out good practices and tools for Juila. Here are some of the tips and tools I've found useful over the years, in the order of usefulness.


@def maxtoclevel=3
\toc

## Put performance critical code inside a function
Julia uses Just-In-Time(JIT) compilation to speed up code execution. In order for JIT compilation to happen, however, your code must be inside a function. Even if you are just playing around with a short code snippet, put it in a function! It can speed up your code by a factor of 100 or more.

## Don't use globals
Global variables slow down your code by a lot. Don't use them. If you really need to, annotate it with `const`, as in

```julia
const NUM = 1
```

But really, unless you know what you are doing, avoid global variables.

## Be careful when you initialize an empty array
In Python, if you want to initialize an empty list, you usually write
```python
arr = []
arr.append([1])
```
And there is no performance penalty to doing this. I can translate this to Julia
```julia
arr = []
append!(arr, [1])
```
However, **this is a very bad code** in julia, if you intend to store only integers in this array. Instead, specify the type of the array like this:
```julia
arr = Int[]
append!(arr, [1])
```
Read the [type stability](https://docs.julialang.org/en/v1/manual/performance-tips/#Write-%22type-stable%22-functions) section of the manual for more information.

## Read performance tips section of the manual
The following two tips are included in the [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/) section of the manual. There are a lot more useful information in the manual. You might not understand some of them yet, but remember this section exists, and come back to it from time to time.

## Use Revise.jl
This one is more about tooling. [Revise.jl](https://github.com/timholy/Revise.jl) is a great package that makes developing Julia code much more efficient. If you are writing anything more than a short Jupyter notebook or short one-use script, you should check out Revise.jl to speed up your code writing process.