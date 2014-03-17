using NumericFunctors
using Base.Test

## auxiliary function

function check_rtype{T<:Number}(f::Functor{1}, ::Type{T})
    pt = result_type(f, T)
    rt = typeof(evaluate(f, one(T)))
    if !(pt == rt)
        error("result_type($f, $T) should be $rt (but predicted $pt)")
    end
end

function check_rtype{T1<:Number,T2<:Number}(f::Functor{2}, ::Type{T1}, ::Type{T2})
    pt = result_type(f, T1, T2)
    rt = typeof(evaluate(f, one(T1), one(T2)))
    if !(pt == rt)
        error("result_type($f, $T1, $T2) should be $rt (but predicted $pt)")
    end
end


## type categories

const inttypes = [Int8, 
                  Int16, 
                  Int32, 
                  Int64, 
                  Int128, 
                  Uint8, 
                  Uint16,
                  Uint32, 
                  Uint64, 
                  Uint128]

const integraltypes = [Bool, inttypes...]
const fptypes = [Float32, Float64]
const realtypes = [integraltypes..., fptypes...]

const complextypes = [Complex{Bool},
                      Complex{Int16}, 
                      Complex{Int32}, 
                      Complex{Int64}, 
                      Complex64, 
                      Complex128]

const numerictypes_r = [realtypes..., Complex64, Complex128]
const numerictypes = [realtypes..., complextypes...]

## test fptype

println("    fptype")

for t in realtypes
    ft = typeof(convert(FloatingPoint, zero(t)))
    @test fptype(t) == ft
end

@test fptype(Complex{Int}) == Complex128
@test fptype(Complex64) == Complex64
@test fptype(Complex128) == Complex128

## arithmetics

println("    arithmetics (unary)")

for F in [Negate, AbsFun, Abs2Fun, RealFun, ImagFun, SqrFun, RcpFun]
    for T in numerictypes
        check_rtype(F(), T) 
    end
end

for F in [SignFun, SignbitFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

println("    arithmetics (binary)")

for F in [Add, Subtract, Multiply, Divide, RDivide, Pow]
    println("        $F")
    for T1 in numerictypes, T2 in numerictypes
        check_rtype(F(), T1, T2)
    end
end

println("    arithmetics (quotient & modulo)")

for F in [DivFun, FldFun, RemFun, ModFun, MaxFun, MinFun]
    println("        $F")
    for T1 in realtypes, T2 in realtypes
        check_rtype(F(), T1, T2)
    end
end

## comparison

println("    comparison operators")

for F in [LT, GT, LE, GE, EQ, NE]
    println("        $F")
    for T1 in realtypes, T2 in realtypes
        check_rtype(F(), T1, T2)
    end  
end


## logical & bitwise

println("    logical operators")

check_rtype(Not(), Bool)
check_rtype(And(), Bool, Bool)
check_rtype(Or(),  Bool, Bool)

println("    bitwise operators")

for T in integraltypes
    check_rtype(BitwiseNot(), T)
end

for F in [BitwiseAnd, BitwiseOr, BitwiseXor]
    for T1 in integraltypes, T2 in integraltypes
        check_rtype(F(), T1, T2)
    end
end

# rounding functions

println("    rounding functions")

for F in [FloorFun, CeilFun, TruncFun, RoundFun, 
          IfloorFun, IceilFun, ItruncFun, IroundFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

# number classification functions

println("    number classification")

for F in [IsnanFun, IsinfFun, IsfiniteFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

# algebraic functions

println("    algebraic functions")

for F in [SqrtFun, RsqrtFun]
    for T in numerictypes
        check_rtype(F(), T)
    end
end

for F in [CbrtFun, RcbrtFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

for T1 in realtypes, T2 in realtypes
    check_rtype(HypotFun(), T1, T2)
end

println("    exponential & logarithm")

for F in [ExpFun, Exp2Fun, Exp10Fun, 
          LogFun, Log2Fun, Log10Fun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

for F in [Expm1Fun, Log1pFun, XlogxFun, 
          SigmoidFun, LogitFun, SoftplusFun, InvsoftplusFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

for F in [XlogyFun, LogsumexpFun]
    for T1 in realtypes, T2 in realtypes
        check_rtype(F(), T1, T2)
    end
end

println("    trigonometric functions")

for F in [SinFun, CosFun, TanFun, CotFun, SecFun, CscFun, 
          AsinFun, AcosFun, AtanFun, AcotFun, AsecFun, AcscFun, 
          SincFun, CoscFun, SinpiFun, CospiFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

for T1 in realtypes, T2 in realtypes
    check_rtype(Atan2Fun(), T1, T2)
end


println("    hyperbolic functions")

for F in [SinhFun, CoshFun, TanhFun, CothFun, SechFun, CschFun, 
          AsinhFun, AcoshFun, AtanhFun, AcothFun, AsechFun, AcschFun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

println("    error functions & friends")

for F in [ErfFun,ErfcFun,ErfiFun,ErfcxFun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

for F in [ErfinvFun, ErfcinvFun]
    for T in realtypes
        check_rtype(F(), T)
    end
end

println("    gamma & friends")

for F in [GammaFun,LgammaFun,EtaFun,ZetaFun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

for T in realtypes
    check_rtype(DigammaFun(), T)
end

println("    beta & lbeta")

for F in [BetaFun, LbetaFun]
    for T1 in realtypes, T2 in realtypes
        check_rtype(F(), T1, T2)
    end    
end

println("    airy & friends")

for F in [AiryFun,AiryprimeFun,AiryaiFun,AiryaiprimeFun,AirybiFun,AirybiprimeFun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

println("    bessel & friends")

for F in [Besselj0Fun, Besselj1Fun, Bessely0Fun, Bessely1Fun]
    for T in numerictypes_r
        check_rtype(F(), T)
    end
end

