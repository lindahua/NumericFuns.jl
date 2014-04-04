# additional math functions & functors

sqr(x::Number) = x * x
rcp(x::Number) = one(x) / x

rsqrt(x::Number) = one(x) / sqrt(x) 
rcbrt(x::Real) = one(x) / cbrt(x)

xlogx(x::FloatingPoint) = x > zero(x) ? x * log(x) : zero(x)
xlogx(x::Real) = xlogx(float(x))

xlogy{T<:FloatingPoint}(x::T, y::T) = x > zero(T) ? x * log(y) : zero(x)
xlogy{T<:Real}(x::T, y::T) = xlogy(float(x), float(y))
xlogy(x::Real, y::Real) = xlogy(promote(x, y)...)

logistic(x::FloatingPoint) = rcp(one(x) + exp(-x))
logistic(x::Real) = logistic(float(x))

logit(x::FloatingPoint) = log(x / (one(x) - x))
logit(x::Real) = logit(float(x))

softplus(x::FloatingPoint) = x <= 0 ? log1p(exp(x)) : x + log1p(exp(-x))
softplus(x::Real) = softplus(float(x))

invsoftplus(x::FloatingPoint) = log(exp(x) - one(x))
invsoftplus(x::Real) = invsoftplus(float(x))

logsumexp{T<:FloatingPoint}(x::T, y::T) = x > y ? x + log1p(exp(y - x)) : y + log1p(exp(x - y))
logsumexp{T<:Real}(x::T, y::T) = logsumexp(float(x), float(y))
logsumexp(x::Real, y::Real) = logsumexp(promote(x, y)...)

@vectorize_1arg Number sqr
@vectorize_1arg Number rcp
@vectorize_1arg Real rsqrt
@vectorize_1arg Real rcbrt

@vectorize_1arg Real xlogx
@vectorize_2arg Real xlogy
@vectorize_1arg Real logistic
@vectorize_1arg Real logit
@vectorize_1arg Real softplus
@vectorize_1arg Real invsoftplus

const sigmoid = logistic
