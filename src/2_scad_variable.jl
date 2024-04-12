_scad_varval(a) = _scad_literal(a)
_scad_varval(a::Vector) = string("[", join(_scad_literal.(a), ", "), "]")
_scad_varval(a::AbstractRange{<:Number}) = string(
    "[", 
        _scad_literal(first(a)), ":", _scad_literal(step(a)), ":", _scad_literal(last(a)), 
    "]"
)

export scad_variable
function scad_variable(id::String, val; suff = ";", comment = "") 
    _valstr = _scad_varval(val);
    _src = string(id, " = ", _valstr)
    _ln = ScadLine(_src, "", 0)
    _ln.suff = suff
    
    # comments
    return _append_comment!([_ln], comment)
end
