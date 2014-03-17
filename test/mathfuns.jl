using NumericFunctors
using Base.Test

@test sqr(2) === 4
@test sqr(2.0) === 4.0

@test rcp(2) === 0.5
@test rsqrt(4) === 0.5
@test rcbrt(8) === 0.5

@test xlogx(0) === 0.0
@test_approx_eq xlogx(2) 2.0 * log(2.0)

@test xlogy(0, 1) === 0.0
@test_approx_eq xlogy(2, 3) 2.0 * log(3.0)

@test_approx_eq sigmoid(2) 1.0 / (1.0 + exp(-2.0))
@test_approx_eq logit(0.5) 0.0
@test_approx_eq logit(sigmoid(2)) 2.0

@test_approx_eq softplus(2.0) log(1.0 + exp(2.0))
@test_approx_eq softplus(-2.0) log(1.0 + exp(-2.0))
@test_approx_eq softplus(10000) 10000.0
@test_approx_eq softplus(-10000) 0.0

@test_approx_eq invsoftplus(softplus(2.0)) 2.0
@test_approx_eq invsoftplus(softplus(-2.0)) -2.0

@test_approx_eq logsumexp(2.0, 3.0) log(exp(2.0) + exp(3.0))
@test_approx_eq logsumexp(10002, 10003) 10000 + logsumexp(2.0, 3.0)

