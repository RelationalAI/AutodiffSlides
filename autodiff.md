class: center, middle

# AutoDiff in Julia

## Chad Scherrer

RelationalAI <br />
April 15, 2020





---

## Running Example: The Rosenbrock Function

````julia
f(x, y; a=1, b=100) = (a - x)^2 + b * (y - x^2)^2

f_vec(x_y) = f(x_y[1], x_y[2])
````






```math
\begin{aligned}
f(x,y) &= (1 - x)^2 + 100 (y - x^2)^2 \\\\
f_x (0,1) &= -2 \\\\
f_y (0,1) &= 200 
\end{aligned}
```

--- 

class: center, middle

# Forward Mode

```math
(x +  Δ x, y + Δ y) → z + Δz
```

---

## [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl)

````julia
using Measurements: ±

x = 0 ± 1; y = 1 ± 1;
z = f(x, y)
````


````
100.0 ± 200.0
````





--

````julia
@show x.tag, y.tag;
````


````
(x.tag, y.tag) = (0x0000000000000008, 0x0000000000000009)
````





--

````julia
z.der
````


````
Measurements.Derivatives{Float64} with 2 entries:
  (1.0, 1.0, 0x0000000000000009) => 200.0
  (0.0, 1.0, 0x0000000000000008) => -2.0
````





--

````julia
y - y # Without tags, this would give 0 ± √2
````


````
0.0 ± 0.0
````






---

## [TaylorSeries.jl](https://github.com/JuliaDiff/TaylorSeries.jl)


````julia
dx, dy = TaylorSeries.set_variables("dx dy", order=3)
x = dx; y = 1 + dy
@show x; @show y;
````


````
x =  1.0 dx + 𝒪(‖x‖⁴)
y =  1.0 + 1.0 dy + 𝒪(‖x‖⁴)
````





--

````julia
z = f(x, y)
````


````
101.0 - 2.0 dx + 200.0 dy - 199.0 dx² + 100.0 dy² - 200.0 dx² dy + 𝒪(‖x‖⁴)
````





--

````julia
TaylorSeries.∇(z)
````


````
2-element Array{TaylorSeries.TaylorN{Float64},1}:
  - 2.0 - 398.0 dx - 400.0 dx dy + 𝒪(‖x‖⁴)
    200.0 + 200.0 dy - 200.0 dx² + 𝒪(‖x‖⁴)
````





---

class: center, middle

# Reverse Mode


```math
(x , y) → (z, Δz → (Δx, Δy))
```

---

## [Zygote.jl](https://fluxml.ai/Zygote.jl/latest/)


````julia
Zygote.gradient(f, 0.0, 1.0)
````


````
(-2.0, 200.0)
````





--

````julia
Zygote.gradient(f_vec, [0.0, 1.0])
````


````
([-2.0, 200.0],)
````




--

````julia
z, back = Zygote.pullback(f, 0.0, 1.0)
````


````
(101.0, Zygote.var"#36#37"{typeof(∂(f))}(∂(f)))
````





--

````julia
back(1)
````


````
(-2.0, 200.0)
````





---

class: center, middle

# Ongoing Work

---

## [ChainRules.jl](https://github.com/JuliaDiff/ChainRules.jl)

- Extensible collection of rules for any source-to-source autodiff

- PR for Zygote: https://github.com/FluxML/Zygote.jl/pull/366

- Very well documented: https://github.com/JuliaDiff/ChainRules.jl

---

## [ForwardDiff2.jl](https://github.com/YingboMa/ForwardDiff2.jl)

ForwardDiff2 = ForwardDiff.jl + ChainRules.jl + Struct of arrays

User API: `D(f)(x)` returns a lazy representation of the derivative.

`D(f)(x) * v` computes `df(x)/dx ⋅ v`, taking advantage of the laziness in `D(f)(x)`.

`DI(f)(x)` is a convenience function to materialize the derivative, gradient or Jacobian of `f` at `x`.

---

class: center, middle

# Fin
