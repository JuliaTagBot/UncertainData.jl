
""" 
    Base.:*(a::UncertainIndexDataset, b::UncertainIndexDataset; n = 30000)

Multiplication operator for two uncertain value datasets. 

To obtain the product for a pair of uncertain values `(xᵢ ∈ a, yᵢ ∈ b)`, both `u₁` and `u₂` are 
resampled `n` times each, so `sample_xᵢ = resample(x, n)` and `sample_yᵢ = resample(y, n)`.

The i-th multiplied uncertain value is a kernel density estimate to those products, i.e.
`mult_val = UncertainValue(UnivariateKDE, sample_xᵢ .* sample_yᵢ)`.
""" 
function Base.:*(a::UncertainIndexDataset, b::UncertainIndexDataset; n = 30000)
    N = length(a)
    n_vals_b = length(b) 

    if N != n_vals_b 
        throw(ArgumentError("Dataset lengths do not match ($N, $n_vals_b)"))
    end

    UncertainIndexDataset([a[i] * b[i] for i = 1:N])
end 

""" 
    Base.:*(a::Real, b::UncertainIndexDataset;
        n = 30000)

Multiplication operator for scalars and uncertain value datasets. 

To obtain the product for a pair of uncertain values `(xᵢ ∈ a, yᵢ ∈ b)`, both `u₁` and `u₂` are 
resampled `n` times each, so `sample_xᵢ = resample(x, n)` and `sample_yᵢ = resample(y, n)`.

The i-th multiplied uncertain value is a kernel density estimate to those products, i.e.
`mult_val = UncertainValue(UnivariateKDE, sample_xᵢ .* sample_yᵢ)`.
""" 
function Base.:*(a::T, b::UncertainIndexDataset; n = 30000) where {T <: Number}
    N = length(a)
    UncertainIndexDataset([a * b[i] for i = 1:N])
end 

""" 
    Base.:*(a::Vector{Real}, b::UncertainIndexDataset;
        n = 30000)

Multiplication operator for scalars and uncertain value datasets. 

To obtain the product for a pair of uncertain values `(xᵢ ∈ a, yᵢ ∈ b)`, both `u₁` and `u₂` are 
resampled `n` times each, so `sample_xᵢ = resample(x, n)` and `sample_yᵢ = resample(y, n)`.

The i-th multiplied uncertain value is a kernel density estimate to those products, i.e.
`mult_val = UncertainValue(UnivariateKDE, sample_xᵢ .* sample_yᵢ)`.
""" 
function Base.:*(a::Vector{T}, b::UncertainIndexDataset; n = 30000) where {T <: Number}
    N = length(a)
    n_vals_b = length(b) 

    if N != n_vals_b 
        throw(ArgumentError("Dataset lengths do not match ($N, $n_vals_b)"))
    end

    UncertainIndexDataset([a[i] * b[i] for i = 1:N])
end 

""" 
    Base.:*(a::UncertainIndexDataset, b::Real; n = 30000)

Multiplication scalars to uncertain value datasets. 

To obtain the product for a pair of uncertain values `(xᵢ ∈ a, yᵢ ∈ b)`, both `u₁` and `u₂` are 
resampled `n` times each, so `sample_xᵢ = resample(x, n)` and `sample_yᵢ = resample(y, n)`.

The i-th multiplied uncertain value is a kernel density estimate to those products, i.e.
`mult_val = UncertainValue(UnivariateKDE, sample_xᵢ .* sample_yᵢ)`.
""" 
function Base.:*(a::UncertainIndexDataset, b::T; n = 30000) where {T <: Number}
    N = length(a)

    UncertainIndexDataset([a[i] * b for i = 1:N])
end 


""" 
    Base.:*(a::UncertainIndexDataset, b::Real; n = 30000)

Multiplication scalars to uncertain value datasets. 

To obtain the product for a pair of uncertain values `(xᵢ ∈ a, yᵢ ∈ b)`, both `u₁` and `u₂` are 
resampled `n` times each, so `sample_xᵢ = resample(x, n)` and `sample_yᵢ = resample(y, n)`.

The i-th multiplied uncertain value is a kernel density estimate to those products, i.e.
`mult_val = UncertainValue(UnivariateKDE, sample_xᵢ .* sample_yᵢ)`.
""" 
function Base.:*(a::UncertainIndexDataset, b::Vector{T}; n = 30000) where {T <: Number}
    N = length(a)
    n_vals_b = length(b) 

    if N != n_vals_b 
        throw(ArgumentError("Dataset lengths do not match ($N, $n_vals_b)"))
    end

    
    UncertainIndexDataset([a[i] * b[i] for i = 1:N])
end 