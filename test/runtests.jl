tests = ["mathfuns", "functors", "rtypes"]

for t in tests
    fp = "$(t).jl"
    println("running $(fp) ...")
    include(fp)
end
