#!/bin/bash

#SBATCH --output=julia_diff.out

# Runtime and memory
#SBATCH --time=00:30:00
#SBATCH --ntasks=16

#### Your shell commands below this line ####

julia -L src/startup.jl src/julia_diff_examples.jl
