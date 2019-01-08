# HPCManager.jl
This packages lunches remote workers in Slurm cluster environment. It parse the environment variable `SLURM_JOB_NODELIST` to get the assigned nodes and their corresponding number of cores, then utilize the internal `addprocs` function to lunch remote workers through `ssh` protocol. A simple usage of this package is to create a start up file `startup.jl` containing
```julia
using Pkg
Pkg.activate(".")
using HPCManager

@everywhere begin
  using Pkg
  Pkg.activate(".")
end
```
then in the `.slurm` file, use the following line to lunch `julia`.
```bash
julia -L startup.jl my_code.jl
```
