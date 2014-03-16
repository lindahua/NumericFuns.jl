#################################################
#
#   Abstract types
#
#################################################

export Functor, evaluate, @functor1, @functor2

abstract Functor{N}  # N is the number of arguments

## macros for defining functors

macro functor1(F, fun, T)
    quote 
        type $F <: Functor{1} end
        global evaluate
        evaluate(::$F, x::$T) = $(fun)(x)
    end
end

macro functor2(F, fun, T)
    quote 
        type $F <: Functor{2} end
        global evaluate
        evaluate(::$F, x::$T, y::$T) = $(fun)(x, y)
    end
end

default_functorsym(f::Symbol) = 
    (fstr = string(fun); symbol(string(uppercase(fstr[1]), fstr[2:end], "Fun")))

macro functor1a(fun, T)
    F = default_functorsym(fun)
    quote
        type $F <: Functor{1} end
        global evaluate
        evaluate(::$F, x::$T) = $(fun)(x)
    end
end

macro functor2a(fun, T)
    F = default_functorsym(fun)
    quote
        type $F <: Functor{2} end
        global evaluate
        evaluate(::$F, x::$T, y::$T) = $(fun)(x, y)
    end
end


#################################################
#
#   Functors
#
#################################################

## arithmetic operators

export Negate, Add, Subtract, Multiply, Divide, RDivide, Pow

@functor1(Negate,   -, Number)
@functor2(Add,      +, Number)
@functor2(Subtract, -, Number)
@functor2(Multiply, *, Number)
@functor2(Divide,   /, Number)
@functor2(RDivide,  \, Number)
@functor2(Pow,      ^, Number)

## comparison operators

export LT, GT, LE, GE, EQ, NE

@functor2(LT, <,  Real)
@functor2(GT, >,  Real)
@functor2(LE, <=, Real)
@functor2(GE, >=, Real)
@functor2(EQ, ==, Real)
@functor2(NE, !=, Real)

## logical & bitwise operators

export Not, And, Or
export BitwiseNot, BitwiseAnd, BitwiseOr, BitwiseXor

@functor1(Not, !, Bool)
@functor2(And, &, Bool)
@functor2(Or,  |, Bool)

@functor1(BitwiseNot, ~, Integer)
@functor2(BitwiseAnd, &, Integer)
@functor2(BitwiseOr,  |, Integer)
@functor2(BitwiseXor, $, Integer)


