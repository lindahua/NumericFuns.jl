using NumericFunctors
using Base.Test

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
const complextypes = [Complex{Int}, Complex64, Complex128]
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
