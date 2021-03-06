# might get removed
# this is almost dup of CxxStd.StdVector

typealias StdVector{T,A} Union{cxxt"std::vector<$T,$A>", cxxt"std::vector<$T,$A>&"}

Base.start(it::StdVector) = 0
Base.next(it::StdVector,i) = (it[i], i+1)
Base.done(it::StdVector,i) = i >= length(it)
Base.getindex(it::StdVector,i) = icxx"($(it))[$i];"
Base.length(it::StdVector) = convert(Int, icxx"$(it).size();")
Base.deleteat!(v::StdVector,idxs::UnitRange) =
    icxx"$(v).erase($(v).begin()+$(first(idxs)),$(v).begin()+$(last(idxs)));"
Base.push!(v::StdVector,i) = icxx"$v.push_back($i);"

function Base.filter!(f, a::StdVector)
    insrt = start(a)
    for curr = start(a):length(a)
        if f(a[curr])
            icxx"$a[$insrt] = $a[$curr];"
            insrt += 1
        end
    end
    if insrt < length(a)
        deleteat!(a, insrt:length(a))
    end
    return a
end
