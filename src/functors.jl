#################################################
#
#   Abstract types
#
#################################################

abstract Functor{N}  # N is the number of arguments

typealias UnaryFunctor Functor{1}
typealias BinaryFunctor Functor{2}
typealias TernaryFunctor Functor{3}

## macros for defining functors

# On 0.4 we can do `function evaluate end` (althought it's probably better)
# to use the call overload when we require julia 0.4
function evaluate() end

macro functor1(F, fun, T)
    eF = esc(F)
    efun = esc(fun)
    eT = esc(T)
    quote
        type $eF <: Functor{1} end
        NumericFuns.evaluate(::$eF, x::$eT) = $efun(x)
    end
end

macro functor2(F, fun, T)
    eF = esc(F)
    efun = esc(fun)
    eT = esc(T)
    quote
        type $eF <: Functor{2} end
        NumericFuns.evaluate(::$eF, x::$eT, y::$eT) = $efun(x, y)
    end
end

default_functorsym(f::Symbol) =
    (fstr = string(f); symbol(string(uppercase(fstr[1]), fstr[2:end], "Fun")))

macro functor1a(fun, T)
    F = default_functorsym(fun)
    eF = esc(F)
    efun = esc(fun)
    eT = esc(T)
    quote
        type $eF <: Functor{1} end
        NumericFuns.evaluate(::$eF, x::$eT) = $efun(x)
    end
end

macro functor2a(fun, T)
    F = default_functorsym(fun)
    eF = esc(F)
    efun = esc(fun)
    eT = esc(T)
    quote
        type $eF <: Functor{2} end
        NumericFuns.evaluate(::$eF, x::$eT, y::$eT) = $efun(x, y)
    end
end

macro functor1a_ord(fun, T)
    F = default_functorsym(fun)
    eF = esc(F)
    efun = esc(fun)
    eT = esc(T)
    quote
        immutable $eF{OT<:Real} <: Functor{1}
            order::OT
        end
        $eF{OT<:Real}(ord::OT) = $eF{OT}(ord)
        NumericFuns.evaluate(f::$eF, x::$eT) = $efun(f.order, x)
    end
end


#################################################
#
#   Functors
#
#################################################

## arithmetic operators

export Negate, Add, Subtract, Multiply, Divide, RDivide, Pow
export FixPow, FixAbsPow

@functor1(Negate,   -, Number)
@functor2(Add,      +, Number)
@functor2(Subtract, -, Number)
@functor2(Multiply, *, Number)
@functor2(Divide,   /, Number)
@functor2(RDivide,  \, Number)
@functor2(Pow,      ^, Number)

immutable FixPow{T<:Real} <: Functor{1}
    p::T
end
evaluate(f::FixPow, x::Real) = x ^ f.p

immutable FixAbsPow{T<:Real} <: Functor{1}
    p::T
end
evaluate(f::FixAbsPow, x::Real) = abs(x) ^ f.p

## comparison operators

export LT, GT, LE, GE, EQ, NE

@functor2(LT, <,  Real)
@functor2(GT, >,  Real)
@functor2(LE, <=, Real)
@functor2(GE, >=, Real)
@functor2(EQ, ==, Number)
@functor2(NE, !=, Number)

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

## arithmetic functions

export DivFun, FldFun, RemFun, ModFun
export AbsFun, Abs2Fun, RealFun, ImagFun, MaxFun, MinFun
export SqrFun, RcpFun, SignFun, SignbitFun

@functor2a div Real
@functor2a fld Real
@functor2a rem Real
@functor2a mod Real

@functor1a abs  Number
@functor1a abs2 Number
@functor1a real Number
@functor1a imag Number
@functor2a max Real
@functor2a min Real

@functor1a sqr Number
@functor1a rcp Number

@functor1a sign     Real
@functor1a signbit  Real

## rounding functions

export FloorFun, CeilFun, TruncFun, RoundFun
export IfloorFun, IceilFun, ItruncFun, IroundFun

@functor1a floor Real
@functor1a ceil  Real
@functor1a trunc Real
@functor1a round Real

_ifloor(x) = floor(Integer, x)
_iceil(x) = ceil(Integer, x)
_itrunc(x) = trunc(Integer, x)
_iround(x) = round(Integer, x)

@functor1 IfloorFun _ifloor Real
@functor1 IceilFun  _iceil  Real
@functor1 ItruncFun _itrunc Real
@functor1 IroundFun _iround Real

## number classification

export IsnanFun, IsinfFun, IsfiniteFun

@functor1a isnan Real
@functor1a isinf Real
@functor1a isfinite Real

## algebraic functions

export SqrtFun, CbrtFun, HypotFun
export RsqrtFun, RcbrtFun

@functor1a sqrt  Number
@functor1a cbrt  Real
@functor2a hypot Real

@functor1a rsqrt Number
@functor1a rcbrt Real


## exponential & logarithm

export ExpFun, Exp2Fun, Exp10Fun, Expm1Fun
export LogFun, Log2Fun, Log10Fun, Log1pFun
export XlogxFun, XlogyFun, LogisticFun, LogitFun
export SoftplusFun, InvsoftplusFun, LogsumexpFun

@functor1a exp   Number
@functor1a exp2  Number
@functor1a exp10 Number
@functor1a expm1 Real

@functor1a log   Number
@functor1a log2  Number
@functor1a log10 Number
@functor1a log1p Real

@functor1a xlogx Real
@functor2a xlogy Real
@functor1a logistic Real
@functor1a logit Real
@functor1a softplus Real
@functor1a invsoftplus Real
@functor2a logsumexp Real

## trigonometric functions

export SinFun, CosFun, TanFun, CotFun, SecFun, CscFun
export AsinFun, AcosFun, AtanFun, AcotFun, AsecFun, AcscFun, Atan2Fun
export SincFun, CoscFun, SinpiFun, CospiFun
export SindFun, CosdFun, TandFun, CotdFun, SecdFun, CscdFun
export AsindFun, AcosdFun, AtandFun, AcotdFun, AsecdFun, AcscdFun

@functor1a sin Number
@functor1a cos Number
@functor1a tan Number
@functor1a cot Number
@functor1a sec Number
@functor1a csc Number

@functor1a asin Number
@functor1a acos Number
@functor1a atan Number
@functor1a acot Number
@functor1a asec Number
@functor1a acsc Number
@functor2a atan2 Real

@functor1a sinc Number
@functor1a cosc Number
@functor1a sinpi Number
@functor1a cospi Number

@functor1a sind Real
@functor1a cosd Real
@functor1a tand Real
@functor1a cotd Real
@functor1a secd Real
@functor1a cscd Real

@functor1a asind Real
@functor1a acosd Real
@functor1a atand Real
@functor1a acotd Real
@functor1a asecd Real
@functor1a acscd Real

## hyperbolic functions

export SinhFun, CoshFun, TanhFun, CothFun, SechFun, CschFun
export AsinhFun, AcoshFun, AtanhFun, AcothFun, AsechFun, AcschFun

@functor1a sinh Number
@functor1a cosh Number
@functor1a tanh Number
@functor1a coth Number
@functor1a sech Number
@functor1a csch Number

@functor1a asinh Number
@functor1a acosh Number
@functor1a atanh Number
@functor1a acoth Number
@functor1a asech Number
@functor1a acsch Number

## special functions

export ErfFun, ErfcFun, ErfinvFun, ErfcinvFun, ErfiFun, ErfcxFun
export GammaFun, LgammaFun, DigammaFun, EtaFun, ZetaFun, BetaFun, LbetaFun
export AiryFun, AiryprimeFun, AiryaiFun, AiryaiprimeFun, AirybiFun, AirybiprimeFun

export Besselj0Fun, Besselj1Fun, Bessely0Fun, Bessely1Fun
export BesseliFun, BesseljFun, BesselkFun, BesselyFun
export Hankelh1Fun, Hankelh2Fun

@functor1a erf Number
@functor1a erfc Number
@functor1a erfinv Real
@functor1a erfcinv Real

@functor1a erfi Number
@functor1a erfcx Number

@functor1a gamma Number
@functor1a lgamma Number
@functor1a digamma Real

@functor1a eta Number
@functor1a zeta Number

@functor2a beta Real
@functor2a lbeta Real

@functor1a airy Number
@functor1a airyprime Number
@functor1a airyai Number
@functor1a airyaiprime Number
@functor1a airybi Number
@functor1a airybiprime Number

@functor1a besselj0 Number
@functor1a besselj1 Number
@functor1a bessely0 Number
@functor1a bessely1 Number

@functor1a_ord besseli Number
@functor1a_ord besselj Number
@functor1a_ord besselk Number
@functor1a_ord bessely Number

@functor1a_ord hankelh1 Number
@functor1a_ord hankelh2 Number

#######################################
#
#  Ternary functors
#
#######################################

export FMA, IfelseFun

type FMA <: Functor{3} end
evaluate(::FMA, x::Number, y::Number, z::Number) = (x + y * z)

type IfelseFun <: Functor{3} end
evaluate{T<:Number}(::IfelseFun, c::Bool, x::T, y::T) = ifelse(c, x, y)
