# result type inference

#################################################
#
#   Auxiliary functions
#
#################################################

# fptype

fptype(::Type{Bool}) = Float32
fptype(::Type{Int8}) = Float32
fptype(::Type{Int16}) = Float32
fptype(::Type{Uint8}) = Float32
fptype(::Type{Uint16}) = Float32

fptype{T<:Integer}(::Type{T}) = Float64
fptype{T<:FloatingPoint}(::Type{T}) = T

fptype{T<:Integer}(::Type{Complex{T}}) = Complex{fptype(T)}
fptype{T<:FloatingPoint}(::Type{Complex{T}}) = Complex{T}


