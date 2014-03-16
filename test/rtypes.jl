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

for F in [Negate, AbsFun, Abs2Fun, RealFun, ImagFun, InvFun]
    for T in numerictypes
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

for F in [DivFun, FldFun, RemFun, ModFun]
    println("        $F")
    for T1 in realtypes, T2 in realtypes
        check_rtype(F(), T1, T2)
    end
end





