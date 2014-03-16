module NumericFunctors

    export 

    # functors (Note: export of specific functors are in functors.jl)
    Functor, UnaryFunctor, BinaryFunctor, TernaryFunctor, 
    evaluate, @functor1, @functor2,

    # rtypes
    fptype, arithtype, result_type


    # source files

    include("functors.jl")
    include("rtypes.jl")

end # module
