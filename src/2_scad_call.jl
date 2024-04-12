# singleline
# NOTE: Overwrite to include custom types
_scad_arg(a) = _scad_literal(a)
_scad_arg(a::Vector) = string("[", join(_scad_literal.(a), ", "), "]")
_scad_arg(a::AbstractRange{<:Number}) = _scad_varval(a)
_scad_arg(a::Pair) =  string(first(a), " = ", _scad_arg(last(a)))

export scad_call
function scad_call(name::String, args...; pref = "", suff = "", comment = "")
    
    # src
    _src = String[]
    push!(_src, name, "(")
    _args_src = String[]
    for arg in args
        push!(_args_src, _scad_arg(arg))
    end
    push!(_src, join(_args_src, ", "))
    push!(_src, ")")

    # preff & suff
    _ln = ScadLine(join(_src), "", 0)
    _ln.pref = pref
    _ln.suff = suff
    
    # comments
    return _append_comment!([_ln], comment)
end

# multiline
# NOTE: Overwrite _scad_mlarg(o)::Vector{ScadLine} include custom types
_scad_mlarg(a::ScadLine) = [a]
_scad_mlarg(a) = [ScadLine(_scad_literal(a))]
function _scad_mlarg(pv::Vector)
    _lines = ScadLine[]
    push!(_lines, ScadLine("[", +1))
    sep = ","
    for (i, p) in enumerate(pv)
        i == lastindex(pv) && (sep = "")
        __lines = _scad_mlarg(p)
        # sl.src = string(sl.src, sep)
        __lines[end].suff = ","
        push!(_lines, __lines...)
    end
    push!(_lines, ScadLine("]", -1))

    return _lines
end
function _scad_mlarg(a::Pair)
    _lines = _scad_mlarg(last(a))
    _lines[1].src = string(
        string(first(a)), " = " , _lines[1].src
    )
    return _lines
end
_scad_mlarg(a::AbstractRange{<:Number}) = _scad_arg(a)

export scad_mlcall
function scad_mlcall(name::String, args...; pref = "", suff = "", comment = "")
    _lines = ScadLine[]
    
    # init call
    _ln = ScadLine(string(name, "(", ), +1)
    _ln.pref = pref
    push!(_lines, _ln)
    
    # args
    _arg_lines = ScadLine[]
    for arg in args
        _ln = _scad_mlarg(arg)
        _ln[end].suff = ","
        push!(_arg_lines, _ln...)
    end
    _arg_lines[end].suff = ""

    push!(_lines, _arg_lines...)

    # close call
    _ln = ScadLine(")", -1)
    _ln.suff = suff
    push!(_lines, _ln)

    # comments
    return _append_comment!(_lines, comment)

end