using NumericFunctors
using Base.Test


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
                (BitwiseXor, $)]

    @test evaluate(F(), 5, 9) == sf(5, 9)
end

