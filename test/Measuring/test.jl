"""
ObsTable(datfile::String)

Read an observable for a properly formatted dat file (i.e. the result of a
`print(datfile,t::ObsTable)`).
"""
function readobstable(datfile::String)
    f = open(datfile,"r")
    header = readline(f)
    header = split(header)
    @assert header[1] == "#"

    colnums = parse.(Int, map(x->split(x,':')[1], header[2:end]))
    names = map(x->split(x,':')[2], header[2:end])

    count = findlast(colnums .== 1:length(colnums))
    nparams = count - 2
    @assert names[nparams+1] ∈ ["num", "samples", "nsamples", "nsamp"]
    res = readdlm(f)
    close(f)

    t = ObsTable()
    set_params_names!(t, names[1:nparams]...)
    onames = String.(names[count:end])
    for i=1:size(res,1)
        pars = (res[i,1:nparams]...)
        nsamp = res[i,nparams+1]
        for j=count:2:size(res,2)
            m, e = res[i,j], res[i,j+1]
            name = onames[(j-count)÷2 + 1]
            if isfinite(m)
                t[pars][name] = obs_from_mean_err_samp(m, e, nsamp)
            end
        end
    end
    return t
end