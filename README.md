# NumericFunctors

Typed functors for numerical computation.
[![Build Status](https://travis-ci.org/lindahua/NumericFunctors.jl.png)](https://travis-ci.org/lindahua/NumericFunctors.jl)

**Note:** This package was originally part of the [NumericExtensions package](https://github.com/lindahua/NumericExtensions.jl). I realized later that the functors and the type inference machinery can be useful in other packages. Hence, I separate this part to construct a standalone package.

-------------

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





