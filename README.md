# HPCManager.jl
This packages launches remote workers in Slurm cluster environment. It parse the environment variable `SLURM_JOB_NODELIST` to get the assigned nodes and their corresponding number of cores, then utilize the internal `addprocs` function to launch remote workers through `ssh` protocol. The simplest way to use this package is to create a start up file `startup.jl` containing the following lines
```julia
using Pkg
Pkg.activate(".")
using HPCManager

@everywhere begin
  using Pkg
  Pkg.activate(".")
end
```
then in the `.slurm` file, `-L` argument to preload this start up file.
```bash
julia -L startup.jl my_code.jl
```
In the above example, it is assumed that this pacakge is installed locally for a `julia` project. A working examples of parallel Mote Carlo simulation using [`DifferentialEquations.jl`](http://docs.juliadiffeq.org/latest/) pacakge can be found in [examples](examples) folder.
