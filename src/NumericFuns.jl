module NumericFuns

    export 

    # mathfuns
    sqr, rcp, rsqrt, rcbrt, xlogx, xlogy, 
    sigmoid, logit, softplus, invsoftplus, logsumexp,

    # functors (Note: export of specific functors are in functors.jl)
    Functor, UnaryFunctor, BinaryFunctor, TernaryFunctor, 
    evaluate, @functor1, @functor2,

    # rtypes
    fptype, arithtype, result_type


    # source files

    include("mathfuns.jl")
    include("functors.jl")
    include("rtypes.jl")
    

end # module
