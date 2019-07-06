@everywhere using DifferentialEquations

prob = ODEProblem((u,p,t)->1.01u,0.5,(0.0,1.0))

@everywhere function prob_func(prob,i,repeat)
  ODEProblem(prob.f,rand()*prob.u0,prob.tspan)
end

monte_prob = MonteCarloProblem(prob,prob_func=prob_func)
sim = solve(monte_prob,Tsit5(),trajectories=100)

@info "Simulation finished!"
