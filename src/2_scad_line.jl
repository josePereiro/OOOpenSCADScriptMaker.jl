export scad_line
function scad_line(line; pref = "", suff = "", comment = "", scope = 0)
    _ln = ScadLine(line)
    _ln.pref = pref
    _ln.suff = suff
    _ln.scope = scope
    return _append_comment!([_ln], comment)
end