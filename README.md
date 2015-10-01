# NumericFuns

Numerical functions and functors.
[![Build Status](https://travis-ci.org/lindahua/NumericFuns.jl.png)](https://travis-ci.org/lindahua/NumericFuns.jl)

**Note:** This package was originally part of the [NumericExtensions package](https://github.com/lindahua/NumericExtensions.jl). I realized later that the functors and the type inference machinery can be useful in other packages. Hence, I separate this part to construct a standalone package.

This package provides:

- Additional numerical functions, such as ``sqr``, ``rsqrt``, ``xlogx``, ``sigmoid``, ``logit``, etc.
- Vectorized methods of the additional numerical functions.
- Typed functors.

-------------

## New Numeric Functions

This package provides several commonly used numerical functions that are not in the Julia Base.

| **function**        | **equivalent expression**         |
| ------------------- | --------------------------------- |
| ``sqr(x)``          |  ``x * x``                        |
| ``rcp(x)``          |  ``1 / x``                        |
| ``rsqrt(x)``        |  ``1 / sqrt(x)``                  |
| ``rcbrt(x)``        |  ``1 / cbrt(x)``                  |
| ``xlogx(x)``        |  ``ifelse(x > 0, x * log(x), 0)`` |
| ``xlogy(x, y)``     |  ``ifelse(x > 0, x * log(y), 0)`` |
| ``sigmoid(x)``      |  ``1 / (1 + exp(-x))``            |
| ``logit(x)``        |  ``log(x / (1 - x))``             |
| ``softplus(x)``     |  ``log(1 + exp(x))``              |
| ``invsoftplus(x)``  |  ``log(exp(x) - 1)``              |
| ``logsumexp(x, y)`` |  ``log(exp(x) + exp(y))``         |

Note that the *equivalent expressions* above are just for the purpose to conveying the semantics. The actual implementation might be different, which would takes a more optimal route that takes care of risk of overflow, type stability, and computational efficiency.


## Functors

*Functors* are typed instances used in indicate a particular function. Since Julia is not able to specialize on functions (yet), functors provide an effective way that allow mutliple dispatch and functional programming to work together.

The package defines an abstract type ``Functor`` as 

```julia
abstract Functor{N}
```
where, ``N`` is an integer indicating the number of arguments. All functor types are subtypes of ``Functor``.

Each functor type comes with an ``evaluate`` method, which evaluates the corresponding function given arguments.

#### Define a functor

Here is an example that illustrates how one can define a functor

```julia
type Add <: Functor{2} end
evaluate{T1<:Number,T2<:Number}(::Add, x::Number, y::Number) = x + y
```

Two macros ``@functor1`` and ``@functor2`` are provided for simplifying the definition of unary and binary functors:

```julia
@functor1(Cbrt, cbrt, Real)
@functor2(Add, +, Number)
```

These macros accept three arguments: the functor type name, the corresponding function, and the super type of all acceptable argument types.

**Note:** The packages also defines a large collection of functors for various mathematical operations (so you don't have to define them yourself).

#### Functors for operators

Here is a table of functor types for operators:

|  **functor type** | **operator** | **domain** |
| ----------------- | ------------ | ---------- |
|  Negate     | ``-``  | Number  |
|  Add        | ``+``  | Number  |
|  Subtract   | ``-``  | Number  |
|  Multiply   | ``*``  | Number  |
|  Divide     | ``/``  | Number  |
|  RDivide    | ``\``  | Number  |
|  Pow        | ``^``  | Number  |
|  And        | ``&``  | Bool    |
|  Or         | &#124; | Bool    |
|  Not        | ``!``  | Bool    | 
|  BitwiseAnd | ``&``  | Integer |
|  BitwiseOr  | &#124; | Integer |
|  BitwiseNot | ``~``  | Integer | 
|  BitwiseXor | ``$``  | Integer | 
|  LT         | ``<``  | Real    |
|  GT         | ``>``  | Real    |
|  LE         | ``<=`` | Real    |
|  GE         | ``>=`` | Real    |
|  EQ         | ``==`` | Number  |
|  NE         | ``!=`` | Number  |


#### Functors for math functions

The package also defined functors for named functions. The naming of functor types follows the ``$(capitalize(funname))Fun`` rule.
For example, the functor type for ``sqrt`` is ``SqrtFun``, and that for ``lgamma`` is ``LgammaFun``, etc.

In particular, the package defines functors for the following functions:

* arithmetic functions

    ```
    abs, abs2, real, imag, sqr, rcp,
    sign, signbit, div, fld, rem, mod
    ```

* rounding functions

    ```
    floor, ceil, trunc, round,
    ifloor, iceil, itrunc, iround
    ```

* number classification functions

    ```isnan, isinf, isfinite```

* algebraic functions

    ```sqrt, rsqrt, cbrt, rcbrt, hypot```

* exponential & logarithm

    ```
    exp, exp2, exp10, expm1,
    log, log2, log10, log1p,

    sigmoid, logit, xlogx, xlogy,
    softplus, invsoftplus, logsumexp
    ```

* trigonometric functions

    ```
    sin, cos, tan, cot, sec, csc,
    asin, acos, atan, acot, asec, acsc, atan2,
    sinc, cosc, sinpi, cospi,
    sind, cosd, tand, cotd, secd, cscd,
    asind, acosd, atand, acotd, asecd, acscd
    ```

* hyperbolic functions

    ```
    sinh, cosh, tanh, coth, sech, csch,
    asinh, acosh, atanh, acoth, asech, acsch
    ```

* special functions

    ```
    erf, erfc, erfinv, erfcinv, erfi, erfcx,
    gamma, lgamma, digamma,
    eta, zeta, beta, lbeta,
    airy, airyprime, airyai, airyaiprime, airybi, airybiprime,
    besselj0, besselj1, bessely0, bessely1
    besseli, besselj, besselk, bessely,
    hankelh1, hankelh2
    ```

## Result Type Inference

Each functor defined in this package comes with ``result_type`` methods that return the type of the result, given the argument types. These methods are thoroughly tested to ensure correctness. For example,

```julia
result_type(Add(), Int, Float64)  # --> returns Float64
result_type(SqrtFun(), Int)   # --> returns Float64
```

The package also provides other convenient methods for type inference, which include ``fptype`` and ``arithtype``. Particularly, we have

```julia
fptype{T<:Real}(::Type{T}) == typeof(Convert(AbstractFloat, one(T)))
fptype{T<:Real}(::Type{Complex{T}}) == Complex{fptype(T)}

arithtype{T1<:Number, T2<:Number} == typeof(one(T1) + one(T2))
```

The internal implementation of these functions are very efficient, usually without actually evaluating the expressions.
