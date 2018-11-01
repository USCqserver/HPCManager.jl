module HPCManager.jl

export init_cluster, close_workers

function init_cluster()
    host_name = gethostname()
    node_list = get_node_list()
    tpn = get_task_per_node()
    tpn = [parse(Int, i) for i in tpn]
    if length(node_list) == 1
        @info "Task is assigned to a single node. Starting with local manager..."
        addprocs(tpn[1]-1)
    else
        if length(tpn) == 1
            tpn = fill(tpn[1], length(node_list))
        end
        machine = []
        for i in zip(node_list, tpn)
            if i[1] == host_name
                push!(machine, (i[1], i[2]-1))
            else
                push!(machine, i)
            end
        end
        @info "Task is assigned to multiple nodes. Starting with SSH manager..."
        @info "Machine configuration: " machine
        addprocs(machine)
    end
end

function close_workers()
	@info "Closing all workers..."
    for i in workers()
		rmprocs(i)
	end
end

function get_node_list()
    slurm_node = ENV["SLURM_JOB_NODELIST"]
    @debug "Slurm node list: " slurm_node
    re = match(r"\[.*\]", slurm_node)
    if re === nothing
        return [slurm_node]
    else
        raw_str = strip(re.match, ['[',']'])
        raw_str = split(raw_str, ',')
        res = []
        for str_iter in raw_str
            if contains(str_iter, "-")
                sp = split(str_iter, '-')
                st = parse(Int, sp[1])
                en = parse(Int, sp[2])
                for n in st:en
                    push!(res, "hpc"*lpad(n,4,0))
                end
            else
                push!(res, "hpc"*str_iter)
            end
        end
        return res
    end
end

function get_task_per_node()
    tpn = ENV["SLURM_TASKS_PER_NODE"]
    @debug "Slurm tasks per node: " tpn
    res = []
    raw_str = split(tpn,',')
    for str_iter in raw_str
        if contains(str_iter, "x")
            x_idx = search(str_iter,'x')
            str = str_iter[1:x_idx-2]
            num = parse(Int, str_iter[x_idx+1:end-1])
            for i in 1:num
                push!(res, str)
            end
        else
            push!(res, str_iter)
        end
    end
    res
end

end # module
