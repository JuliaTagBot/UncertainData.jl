import UncertainData: 
    UncertainDataset, 
    resample, 
    UncertainValue, 
    StrictlyIncreasing,
    
    NoConstraint,
    TruncateLowerQuantile,
    TruncateUpperQuantile,
    TruncateQuantiles,
    TruncateMinimum,
    TruncateMaximum,
    TruncateRange,
    TruncateStd

import Distributions: 
    Uniform, 
    Normal

import Test 

# Create some uncertain data with increasing magnitude and zero overlap between values, 
# so we're guaranteed that a strictly increasing sequence through the dataset exists.
N = 10
u_timeindices = [ i <= N/2 ? CertainValue(float(i)) : UncertainValue(Normal, i, 1) for i = 1:N]
UI = UncertainIndexDataset(u_timeindices)
UV = UncertainValueDataset(u_timeindices)

# No further constraints other than the order constraint
x = resample(UI, StrictlyIncreasing())
@test x isa Vector{Float64}

n_realizations = 100
X = [resample(UI, StrictlyIncreasing()) for i = 1:n_realizations]

# We're getting vectors 
@test all([x isa Vector{Float64} for x in X])

# All sequences 
@test all([all(diff(x) .> 0) for x in X])

test_constraints = [
    NoConstraint(), 
    TruncateLowerQuantile(0.2), 
    TruncateUpperQuantile(0.2),
    TruncateQuantiles(0.2, 0.8),
    TruncateMaximum(50),
    TruncateMinimum(-50),
    TruncateRange(-50, 50),
    TruncateStd(1)
]


# First constrain using a single regular constraint, then apply the order constraint.  
for i = 1:length(test_constraints)
    constraint = test_constraints[i]    
    @test resample(UI, constraint, StrictlyIncreasing()) isa Vector{Float64}
    @test all([resample(UI, constraint, StrictlyIncreasing()) isa Vector{Float64} for k = 1:n_realizations])
end

#First element-wise apply a vector of regular constraints to each element in the dataset, 
#then apply the order constraint.  
for i = 1:length(test_constraints)
    constraints = [test_constraints[i] for k = 1:length(UI)]
    @test resample(UI, constraints, StrictlyIncreasing()) isa Vector{Float64}
    @test all([resample(UI, constraints, StrictlyIncreasing()) isa Vector{Float64} for k = 1:n_realizations])
end


# Index-value 
iv = UncertainIndexValueDataset(UI, UV)

# Sequential
@test resample(iv, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}

# First constrain using a single regular constraint, then apply the order constraint.  
for i = 1:length(test_constraints)
    constraint = test_constraints[i]
    @test resample(iv, constraint, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}
    @test resample(iv, constraint, constraint, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}
    @test all([resample(iv, constraint, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}} for k = 1:n_realizations])
    @test all([resample(iv, constraint, constraint, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}} for k = 1:n_realizations])

    cs = [test_constraints[i] for k = 1:length(UI)]

    @test resample(iv, cs, cs, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}
    @test resample(iv, cs, constraint, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}
    @test resample(iv, constraint, cs, StrictlyIncreasing()) isa Tuple{Vector{Float64}, Vector{Float64}}
end

