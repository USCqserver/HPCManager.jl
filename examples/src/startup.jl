using Pkg
Pkg.activate(".")
using HPCManager

init_cluster()

@everywhere begin
	using Pkg
	Pkg.activate(".")
end
