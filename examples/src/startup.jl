using Pkg
Pkg.activate(".")
using HPCManager

@everywhere begin
	using Pkg
	Pkg.activate(".")
end
