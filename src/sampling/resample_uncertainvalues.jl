resample(fd::FittedDistribution) = UncertainValues.resample(fd)
resample(uv::AbstractUncertainValue) = UncertainValues.resample(uv)
resample(uv::AbstractUncertainValue, n::Int) =
    UncertainValues.resample(uv, n)

resample(uv::UncertainScalarEmpiricallyDistributed) =
    UncertainValues.resample(uv)
resample(uv::UncertainScalarEmpiricallyDistributed, n::Int) =
    UncertainValues.resample(uv, n)

"""
Resample an uncertain value given a sampling constraint.
"""
function resample(uv::AbstractUncertainValue, constraint::C) where {C<:SamplingConstraint} end

"""
    resample(uv::AbstractUncertainValue, constraint::NoConstraint)

Resample without contraints (use the full distribution representing the value)

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)

# Resample the uncertain value by resampling the full distribution once.
resample(uncertainval, NoConstraint())
```
"""
resample(uv::AbstractUncertainValue, constraint::NoConstraint) = resample(uv)

"""
    resample(uv::AbstractUncertainValue, constraint::NoConstraint, n::Int)

Resample without contraints (use the full distribution representing the value)

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)

# Resample the uncertain value by resampling the full distribution 1000 times.
resample(uncertainval, NoConstraint(), 1000)
```
"""
resample(uv::AbstractUncertainValue, constraint::NoConstraint, n::Int) = resample(uv, n)

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateUpperQuantile)

Resample by first truncating the distribution representing the value at a lower
quantile, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateLowerQuantile(0.16)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateLowerQuantile)
    # Apply (another level of) truncation, then sample
    lower_bound = quantile(uv.distribution, constraint.lower_quantile)
    upper_bound = support(uv.distribution).ub
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateLowerQuantile, n::Int)

Resample by first truncating the distribution representing the value at a lower
quantile, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateLowerQuantile(0.16)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateLowerQuantile, n::Int)
    # Apply (another level of) truncation, then sample
    lower_bound = quantile(uv.distribution, constraint.lower_quantile)
    upper_bound = support(uv.distribution).ub
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateUpperQuantile)

Resample by first truncating the distribution representing the value at an upper
quantile, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateUpperQuantile(0.8)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateUpperQuantile)
    # Apply (another level of) truncation, then sample
    lower_bound = support(uv.distribution).lb
    upper_bound = quantile(uv.distribution, constraint.upper_quantile)
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateUpperQuantile, n::Int)

Resample by first truncating the distribution representing the value at an upper
quantile, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateUpperQuantile(0.8)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateUpperQuantile, n::Int)
    # Apply (another level of) truncation, then sample
    lower_bound = support(uv.distribution).lb
    upper_bound = quantile(uv.distribution, constraint.upper_quantile)
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateQuantiles)

Resample by first truncating the distribution representing the value at a set of
qunatiles, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 1, Uniform)
constraint = TruncateLowerQuantile(0.2)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateQuantiles)
    # Apply (another level of) truncation, then sample
    lower_bound = quantile(uv.distribution, constraint.lower_quantile)
    upper_bound = quantile(uv.distribution, constraint.upper_quantile)
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateQuantiles, n::Int)

Resample by first truncating the distribution representing the value at a set of
qunatiles, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 1, Uniform)
constraint = TruncateLowerQuantile(0.2)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateQuantiles, n::Int)
    # Apply (another level of) truncation, then sample
    lower_bound = quantile(uv.distribution, constraint.lower_quantile)
    upper_bound = quantile(uv.distribution, constraint.upper_quantile)
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end


"""
resample(uv::AbstractUncertainValue, constraint::TruncateStd)

Resample by first truncating the distribution representing the value at ``\\pm``
`nσ`, then performing the resampling.


## Example

```julia
uncertainval = UncertainValue(0, 1, Uniform)
constraint = TruncateStd(2) # truncate at 2 standard deviations

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once times.
resample(uncertainval, constraint)
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateStd)
    σ, nσ = std(uv.distribution), constraint.nσ

    # Apply (another level of) truncation, then sample
    lower_bound = mean(uv.distribution) - σ * nσ
    upper_bound = mean(uv.distribution) + σ * nσ
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
resample(uv::AbstractUncertainValue, constraint::TruncateStd, n::Int)

Resample by first truncating the distribution representing the value at ``\\pm``
`nσ`, then performing the resampling.


## Example

```julia
uncertainval = UncertainValue(0, 1, Uniform)
constraint = TruncateStd(0.3, 2) # truncate at 2σ = 2*0.3

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateStd, n::Int)
    σ, nσ = std(uv.distribution), constraint.nσ

    # Apply (another level of) truncation, then sample
    lower_bound = mean(uv.distribution) - σ * nσ
    upper_bound = mean(uv.distribution) + σ * nσ
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end


"""
    resample(uv::AbstractUncertainValue, constraint::TruncateMinimum)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateMinimum(-0.5) # accept no values less than -0.5

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateMinimum)
    # Apply (another level of) truncation, then sample
    lower_bound = constraint.min
    upper_bound = support(uv.distribution).ub
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateMinimum, n::Int)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.2, Normal)
constraint = TruncateMinimum(-0.5)

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateMinimum, n::Int)
    # Apply (another level of) truncation, then sample
    lower_bound = constraint.min
    upper_bound = support(uv.distribution).ub
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end



"""
    resample(uv::AbstractUncertainValue, constraint::TruncateMaximum)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.8, Normal)
constraint = TruncateMaximum(1.1) # accept no values larger than 1.1

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateMaximum)
    # Apply (another level of) truncation, then sample
    upper_bound = constraint.max
    lower_bound = support(uv.distribution).lb
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateMaximum, n::Int)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.8, Normal)
constraint = TruncateMaximum(1.1) # accept no values larger than 1.1

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateMaximum, n::Int)
    # Apply (another level of) truncation, then sample
    upper_bound = constraint.max
    lower_bound = support(uv.distribution).lb
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end



"""
    resample(uv::AbstractUncertainValue, constraint::TruncateRange)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.8, Normal)
constraint = TruncateRange(-0.7, 1.1) # accept values only in range [-0.7, 1.1]

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution once.
resample(uncertainval, constraint)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateRange)
    # Apply (another level of) truncation, then sample
    upper_bound = constraint.max
    lower_bound = constraint.min
    rand(Truncated(uv.distribution, lower_bound, upper_bound))
end

"""
    resample(uv::AbstractUncertainValue, constraint::TruncateRange, n::Int)

Resample by first truncating the distribution representing the value at some
minimum value, then performing the resampling.

## Example

```julia
uncertainval = UncertainValue(0, 0.8, Normal)
constraint = TruncateRange(-0.7, 1.1) # accept values only in range [-0.7, 1.1]

# Resample the uncertain value by truncating the distribution furnishing it,
# then resampling the new distribution 1000 times.
resample(uncertainval, constraint, 1000)
```
"""
function resample(uv::AbstractUncertainValue, constraint::TruncateRange, n::Int)
    # Apply (another level of) truncation, then sample
    upper_bound = constraint.max
    lower_bound = constraint.min
    rand(Truncated(uv.distribution, lower_bound, upper_bound), n)
end

export resample
