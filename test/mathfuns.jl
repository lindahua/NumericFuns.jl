using NumericFuns
using Base.Test

@test sqr(2) === 4
@test sqr(2.0) === 4.0

@test rcp(2) === 0.5
@test rsqrt(4) === 0.5
@test rcbrt(8) === 0.5

@test xlogx(0) === 0.0
@test xlogx(2) ≈ 2.0 * log(2.0)

@test xlogy(0, 1) === 0.0
@test xlogy(2, 3) ≈ 2.0 * log(3.0)

@test logistic(2) ≈ 1.0 / (1.0 + exp(-2.0))
@test logit(0.5) ≈ 0.0
@test logit(sigmoid(2)) ≈ 2.0

@test softplus(2.0) ≈ log(1.0 + exp(2.0))
@test softplus(-2.0) ≈ log(1.0 + exp(-2.0))
@test softplus(10000) ≈ 10000.0
@test softplus(-10000) ≈ 0.0

@test invsoftplus(softplus(2.0)) ≈ 2.0
@test invsoftplus(softplus(-2.0)) ≈ -2.0

@test logsumexp(2.0, 3.0) ≈ log(exp(2.0) + exp(3.0))
@test logsumexp(10002, 10003) ≈ 10000 + logsumexp(2.0, 3.0)

