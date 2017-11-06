using NumericFuns
using Base.Test
using Compat

println("    macros")
test_unary(x) = -x
test_binary(x, y) = x + y
@functor1(TestUnary, test_unary, Number)
@functor2(TestBinary, test_binary, Number)

@test evaluate(TestUnary(), 3) == -3
@test evaluate(TestBinary(), 3, 4) == 7

println("    arithmetic operators")

@test evaluate(Negate(), 2) == -2

for (F, sf) in [(Add, +),
                (Subtract, -),
                (Multiply, *),
                (Divide, /),
                (RDivide, \),
                (Pow, ^)]

    @test evaluate(F(), 6, 2) == sf(6, 2)
    @test evaluate(F(), 5.0, 2.0) == sf(5.0, 2.0)
end

println("    comparison operators")

for (F, sf) in [(LT, <),
                (GT, >),
                (LE, <=),
                (GE, >=),
                (EQ, ==),
                (NE, !=)]

    @test evaluate(F(), 1, 1) == sf(1, 1)
    @test evaluate(F(), 1, 2) == sf(1, 2)
    @test evaluate(F(), 2, 1) == sf(2, 1)
end

println("    logical operators")

@test evaluate(Not(), true) == false
@test evaluate(Not(), false) == true

@test evaluate(And(), false, false) == false
@test evaluate(And(), false, true)  == false
@test evaluate(And(), true,  false) == false
@test evaluate(And(), true,  true)  == true

@test evaluate(Or(), false, false) == false
@test evaluate(Or(), false, true)  == true
@test evaluate(Or(), true,  false) == true
@test evaluate(Or(), true,  true)  == true

println("    bitwise operators")

@test evaluate(BitwiseNot(), 5) == ~5

for (F, sf) in [(BitwiseAnd, &), 
                (BitwiseOr,  |), 
                (BitwiseXor, ⊻)]

    @test evaluate(F(), 5, 9) == sf(5, 9)
end

println("    arithmetic functions")

for (F, sf) in [(DivFun, div), 
                (FldFun, fld), 
                (RemFun, rem), 
                (ModFun, mod), 
                (MaxFun, max), 
                (MinFun, min)]

    @test evaluate(F(),  14, 3) == sf( 14, 3)
    @test evaluate(F(), -14, 3) == sf(-14, 3)
end

for (F, sf) in [(AbsFun, abs), 
                (Abs2Fun, abs2), 
                (RealFun, real), 
                (ImagFun, imag)]

    @test evaluate(F(), 5.0) == sf(5.0)
    @test evaluate(F(), -5.0) == sf(-5.0)
    @test evaluate(F(), 3.0 + 4.0im) == sf(3.0 + 4.0im)
end

for (F, sf) in [(SignFun, sign), 
                (SignbitFun, signbit)]

    @test evaluate(F(),  0) == sf(0)
    @test evaluate(F(),  1) == sf(1)
    @test evaluate(F(), -1) == sf(-1)
end

println("    rounding functions")

for (F, sf) in [(FloorFun, floor),
                (CeilFun, ceil),
                (TruncFun, trunc),
                (RoundFun, round),
                (IfloorFun, x->floor(Integer, x)),
                (IceilFun, x->ceil(Integer, x)),
                (ItruncFun, x->trunc(Integer, x)),
                (IroundFun, x->round(Integer, x))]

    @test evaluate(F(),  3.4) === sf(3.4)
    @test evaluate(F(),  3.8) === sf(3.8)
    @test evaluate(F(), -3.4) === sf(-3.4)
    @test evaluate(F(), -3.8) === sf(-3.8)
end

println("    algebraic functions")

for (F, sf) in [(SqrtFun, sqrt), (CbrtFun, cbrt)]
    @test evaluate(F(), 64.0) == sf(64.0)
end

@test evaluate(HypotFun(), 3.0, 4.0) == hypot(3.0, 4.0)

println("    trancendental functions")

for (F, sf) in [(ExpFun, exp), 
                (Exp2Fun, exp2), 
                (Exp10Fun, exp10), 
                (Expm1Fun, expm1), 
                (LogFun, log), 
                (Log2Fun, log2), 
                (Log10Fun, log10), 
                (Log1pFun, log1p), 
                (SinFun, sin), 
                (SinhFun, sinh), 
                (SindFun, sind), 
                (SincFun, sinc), 
                (SinpiFun, sinpi),
                (AtanFun, atan), 
                (AtandFun, atand)]

    @test evaluate(F(), 3.0) == sf(3.0)
end

@test evaluate(Atan2Fun(), 3.0, 4.0) == atan2(3.0, 4.0)


println("    special functions")

for (Fun, sf) in [(ErfFun(), erf), 
                  (GammaFun(), gamma), 
                  (AiryaiFun(), airyai), 
                  (Besselj0Fun(), besselj0),            
                  (BesseljFun(2), x -> besselj(2, x))]

    @test evaluate(Fun, 2.0) == sf(2.0)
    @test evaluate(Fun, 1.0 + 2.0im) == sf(1.0 + 2.0im)
end

