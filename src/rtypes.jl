# result type inference

#################################################
#
#   Auxiliary functions
#
#################################################

## fptype

fptype{T<:Union(Bool,Int8,Int16,Uint8,Uint16)}(::Type{T}) = Float32
fptype{T<:Integer}(::Type{T}) = Float64
fptype{T<:FloatingPoint}(::Type{T}) = T

fptype{T<:Integer}(::Type{Complex{T}}) = Complex{fptype(T)}
fptype{T<:FloatingPoint}(::Type{Complex{T}}) = Complex{T}

## signed & unsigned type

signedtype{T<:Signed}(::Type{T}) = T
signedtype(::Type{Uint8}) = Int8
signedtype(::Type{Uint16}) = Int16
signedtype(::Type{Uint32}) = Int32
signedtype(::Type{Uint64}) = Int64
signedtype(::Type{Uint128}) = Int128

unsignedtype{T<:Unsigned}(::Type{T}) = T
unsignedtype(::Type{Int8}) = Uint8
unsignedtype(::Type{Int16}) = Uint16
unsignedtype(::Type{Int32}) = Uint32
unsignedtype(::Type{Int64}) = Uint64
unsignedtype(::Type{Int128}) = Uint128

## arithtype (unary)

arithtype(::Type{Bool}) = Int64
arithtype{T<:Signed}(::Type{T}) = Int64
arithtype{T<:Unsigned}(::Type{T}) = Uint64
arithtype(::Type{Int128}) = Int128
arithtype(::Type{Uint128}) = Uint128

arithtype(::Type{Float32}) = Float32
arithtype(::Type{Float64}) = Float64
arithtype(::Type{Complex64}) = Complex64
arithtype(::Type{Complex128}) = Complex128
arithtype{T<:Integer}(::Type{Complex{T}}) = Complex{arithtype(T)}

## arithtype (binary)

arithtype{T<:Real}(::Type{T},::Type{T}) = arithtype(T)
arithtype{T1<:Real,T2<:Real}(::Type{T1}, ::Type{T2}) = arithtype(promote_type(T1, T2))
arithtype{T1<:Real,T2<:Real}(::Type{T1}, ::Type{Complex{T2}}) = Complex{arithtype(T1,T2)}
arithtype{T1<:Real,T2<:Real}(::Type{Complex{T1}}, ::Type{T2}) = Complex{arithtype(T1,T2)}
arithtype{T1<:Real,T2<:Real}(::Type{Complex{T1}}, ::Type{Complex{T2}}) = Complex{arithtype(T1,T2)}


#################################################
#
#   result type inference
#
#################################################

## arithmetics

# negate

result_type{T<:Number}(::Negate, ::Type{T}) = arithtype(T)

# abs

result_type{T<:Number}(::AbsFun, ::Type{T}) = arithtype(T)
result_type(::AbsFun, ::Type{Bool}) = Bool
result_type{T<:Unsigned}(::AbsFun, ::Type{T}) = T
result_type{T<:Real}(::AbsFun, ::Type{Complex{T}}) = fptype(T)

# abs2

result_type{T<:Number}(::Abs2Fun, ::Type{T}) = arithtype(T)
result_type(::Abs2Fun, ::Type{Bool}) = Bool
result_type{T<:Real}(::Abs2Fun, ::Type{Complex{T}}) = arithtype(T)

# sqr

result_type(::SqrFun, ::Type{Bool}) = Bool
result_type{T<:Number}(::SqrFun, ::Type{T}) = arithtype(T)

# real & imag

result_type{T<:Real}(::Union(RealFun,ImagFun), ::Type{T}) = T
result_type{T<:Real}(::Union(RealFun,ImagFun), ::Type{Complex{T}}) = T

# sign & signbit

result_type{T<:Real}(::SignFun, ::Type{T}) = T
result_type{T<:Real}(::SignbitFun, ::Type{T}) = Int

# add & subtract

result_type{T1<:Number,T2<:Number}(::Union(Add,Subtract), ::Type{T1}, ::Type{T2}) = arithtype(T1, T2)

# multiply

result_type{T1<:Real,T2<:Real}(::Multiply, ::Type{T1}, ::Type{T2}) = arithtype(T1,T2)
result_type(::Multiply, ::Type{Bool}, ::Type{Bool}) = Bool
result_type{T<:Real}(::Multiply, ::Type{Bool}, ::Type{T}) = T
result_type{T<:Real}(::Multiply, ::Type{T}, ::Type{Bool}) = T

result_type{T1<:Real,T2<:Real}(::Multiply, ::Type{Complex{T1}}, ::Type{Complex{T2}}) = 
    Complex{arithtype(T1, T2)}
result_type{T1<:Real,T2<:Real}(op::Multiply, ::Type{T1}, ::Type{Complex{T2}}) = 
    Complex{result_type(op, T1, T2)}
result_type{T1<:Real,T2<:Real}(op::Multiply, ::Type{Complex{T1}}, ::Type{T2}) = 
    Complex{result_type(op, T1, T2)}

# divide

result_type{T1<:Real,T2<:Real}(::Divide, ::Type{T1}, ::Type{T2}) = promote_type(T1, T2)
result_type{T1<:Integer,T2<:Integer}(::Divide, ::Type{T1}, ::Type{T2}) = 
    promote_type(fptype(T1), fptype(T2))

result_type{T1<:Real,T2<:Complex}(op::Divide, ::Type{T1}, ::Type{T2}) = 
    result_type(Multiply(), T1, fptype(T2))

result_type{T1<:Real,T2<:Real}(op::Divide, ::Type{Complex{T1}}, ::Type{T2}) = 
    Complex{result_type(op, T1, T2)}

result_type{T1<:Complex,T2<:Complex}(op::Divide, ::Type{T1}, ::Type{T2}) = 
    result_type(Multiply(), T1, fptype(T2))

# rdivide

result_type{T1<:Number,T2<:Number}(::RDivide, ::Type{T1}, ::Type{T2}) = 
    result_type(Divide(), T2, T1)

# rcp

result_type{T<:Number}(::RcpFun, ::Type{T}) = fptype(T)
 
# pow

result_type(::Pow, ::Type{Bool}, ::Type{Bool}) = Bool
result_type{T<:Real}(::Pow, ::Type{T}, ::Type{Bool}) = T

result_type{T2<:Integer}(::Pow, ::Type{Bool}, ::Type{T2}) = Bool
result_type{T1<:Real,T2<:Integer}(::Pow, ::Type{T1}, ::Type{T2}) = arithtype(T1)
result_type{T1<:Real,T2<:Real}(::Pow, ::Type{T1}, ::Type{T2}) = fptype(promote_type(T1, T2))

result_type{T1<:Real}(::Pow, ::Type{Complex{T1}}, ::Type{Bool}) = Complex{T1}
result_type{T1<:Real,T2<:Integer}(::Pow, ::Type{Complex{T1}}, ::Type{T2}) = Complex{arithtype(T1)}

result_type{T1<:Real,T2<:Real}(::Pow, ::Type{Complex{T1}}, ::Type{T2}) = 
    Complex{fptype(promote_type(T1, T2))}
result_type{T1<:Real,T2<:Real}(::Pow, ::Type{T1}, ::Type{Complex{T2}}) = 
    Complex{fptype(promote_type(T1, T2))}
result_type{T1<:Real,T2<:Real}(::Pow, ::Type{Complex{T1}}, ::Type{Complex{T2}}) = 
    Complex{fptype(promote_type(T1, T2))}

# max & min

result_type{T<:Real}(::Union(MaxFun,MinFun), ::Type{T}, ::Type{T}) = T
result_type{T1<:Real,T2<:Real}(::Union(MaxFun,MinFun), ::Type{T1}, ::Type{T2}) = promote_type(T1, T2)


# quotient & module

result_type{T1<:Real,T2<:Real}(::Union(DivFun,RemFun), ::Type{T1}, ::Type{T2}) = promote_type(T1, T2)

result_type{T1<:Signed,T2<:Unsigned}(::Union(DivFun,RemFun), ::Type{T1}, ::Type{T2}) = 
    signedtype(promote_type(T1, T2))
result_type{T1<:Unsigned,T2<:Signed}(::Union(DivFun,RemFun), ::Type{T1}, ::Type{T2}) = 
    unsignedtype(promote_type(T1, T2))

result_type{T1<:Real,T2<:Real}(::FldFun, ::Type{T1}, ::Type{T2}) = 
    arithtype(T1, T2)
result_type{T1<:Union(Unsigned,Bool), T2<:Union(Unsigned,Bool)}(::FldFun, ::Type{T1}, ::Type{T2}) = 
    promote_type(T1, T2)
result_type{T1<:Signed,T2<:Unsigned}(::FldFun, ::Type{T1}, ::Type{T2}) = 
    signedtype(promote_type(T1, T2))
result_type{T1<:Unsigned,T2<:Signed}(::FldFun, ::Type{T1}, ::Type{T2}) = 
    unsignedtype(promote_type(T1, T2))

result_type{T1<:Real,T2<:Real}(::ModFun, ::Type{T1}, ::Type{T2}) = promote_type(T1, T2)
result_type{T1<:Signed,T2<:Unsigned}(::ModFun, ::Type{T1}, ::Type{T2}) = unsignedtype(promote_type(T1, T2))
result_type{T1<:Unsigned,T2<:Signed}(::ModFun, ::Type{T1}, ::Type{T2}) = signedtype(promote_type(T1, T2))

# fma

result_type{T1<:Number,T2<:Number,T3<:Number}(::FMA, ::Type{T1}, ::Type{T2}, ::Type{T3}) = 
    result_type(Add(), T1, result_type(Multiply(), T2, T3))

# ifelse

result_type{T<:Number}(::IfelseFun, ::Type{Bool}, ::Type{T}, ::Type{T}) = T


# logical

result_type(::Not, ::Type{Bool}) = Bool
result_type(::And, ::Type{Bool}, ::Type{Bool}) = Bool
result_type(::Or, ::Type{Bool}, ::Type{Bool}) = Bool

# bitwise

result_type{T<:Integer}(::BitwiseNot, ::Type{T}) = T

result_type{T1<:Integer,T2<:Integer}(::Union(BitwiseAnd,BitwiseOr,BitwiseXor), ::Type{T1}, ::Type{T2}) = 
    promote_type(T1, T2)

# comparison

result_type{T1<:Real,T2<:Real}(::Union(LT,GT,LE,GE), ::Type{T1}, ::Type{T2}) = Bool
result_type{T1<:Number,T2<:Number}(::Union(EQ,NE), ::Type{T1}, ::Type{T2}) = Bool

# rounding

result_type{T<:Real}(::Union(FloorFun, CeilFun, TruncFun, RoundFun), ::Type{T}) = T
result_type{T<:Integer}(::Union(IfloorFun, IceilFun, ItruncFun, IroundFun), ::Type{T}) = T
result_type{T<:FloatingPoint}(::Union(IfloorFun, IceilFun, ItruncFun, IroundFun), ::Type{T}) = Int64

# algebraic functions

result_type{T<:Number}(::Union(SqrtFun,CbrtFun,RsqrtFun,RcbrtFun), ::Type{T}) = fptype(T)
result_type{T1<:Real,T2<:Real}(::HypotFun, ::Type{T1}, ::Type{T2}) = promote_type(fptype(T1), fptype(T2))

# exponential & logarithm

result_type{T<:Number}(::Union(ExpFun,Exp2Fun,Exp10Fun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(LogFun,Log2Fun,Log10Fun), ::Type{T}) = fptype(T)
result_type{T<:Real}(::Union(Expm1Fun,Log1pFun), ::Type{T}) = fptype(T)

result_type{T<:Real}(::Union(XlogxFun,SigmoidFun,LogitFun,SoftplusFun,InvsoftplusFun), ::Type{T}) = fptype(T)
result_type{T1<:Real,T2<:Real}(::XlogyFun, ::Type{T1}, ::Type{T2}) = fptype(promote_type(T1, T2))
result_type{T1<:Real,T2<:Real}(::LogsumexpFun, ::Type{T1}, ::Type{T2}) = fptype(promote_type(T1, T2))

# trigonometric functions

result_type{T<:Number}(::Union(SinFun,CosFun,TanFun,CotFun,SecFun,CscFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(AsinFun,AcosFun,AtanFun,AcotFun,AsecFun,AcscFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(SincFun,CoscFun,SinpiFun,CospiFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(SindFun,CosdFun,TandFun,CotdFun,SecdFun,CscdFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(AsindFun,AcosdFun,AtandFun,AcotdFun,AsecdFun,AcscdFun), ::Type{T}) = fptype(T)

result_type{T<:Integer}(::SincFun, ::Type{T}) = T
result_type{T<:Integer}(::SinpiFun, ::Type{T}) = T
result_type{T<:Integer}(::CospiFun, ::Type{T}) = arithtype(T)

result_type{T1<:Real,T2<:Real}(::Atan2Fun, ::Type{T1}, ::Type{T2}) = promote_type(fptype(T1), fptype(T2))

# hyperbolic functions

result_type{T<:Number}(::Union(SinhFun,CoshFun,TanhFun,CothFun,SechFun,CschFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(AsinhFun,AcoshFun,AtanhFun,AcothFun,AsechFun,AcschFun), ::Type{T}) = fptype(T)

# erf & friends

result_type{T<:Number}(::Union(ErfFun,ErfcFun,ErfiFun,ErfcxFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(ErfinvFun,ErfcinvFun), ::Type{T}) = fptype(T)

# gamma, beta, & friends

result_type{T<:Number}(::Union(GammaFun,LgammaFun,EtaFun,ZetaFun), ::Type{T}) = fptype(T)
result_type{T<:Integer}(::Union(EtaFun,ZetaFun), ::Type{T}) = Float64

result_type(::Union(GammaFun,LgammaFun), ::Type{Complex64}) = Complex128

result_type{T<:FloatingPoint}(::DigammaFun, ::Type{T}) = T
result_type{T<:Integer}(::DigammaFun, ::Type{T}) = Float64

result_type{T1<:Real,T2<:Real}(::Union(BetaFun,LbetaFun), ::Type{T1}, ::Type{T2}) =
    promote_type(fptype(T1),fptype(T2))

result_type{T1<:Integer,T2<:Integer}(::Union(BetaFun,LbetaFun), ::Type{T1}, ::Type{T2}) = Float64

# airy & friends

result_type{T<:Number}(::Union(AiryFun,AiryprimeFun,AiryaiFun,AiryaiprimeFun,AirybiFun,AirybiprimeFun),::Type{T}) = 
    fptype(T)

# bessel & friends

result_type{T<:Number}(::Union(Besselj0Fun, Besselj1Fun, Bessely0Fun, Bessely1Fun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(BesseliFun, BesseljFun, BesselkFun, BesselyFun), ::Type{T}) = fptype(T)
result_type{T<:Number}(::Union(Hankelh1Fun, Hankelh2Fun), ::Type{T}) = fptype(T)

