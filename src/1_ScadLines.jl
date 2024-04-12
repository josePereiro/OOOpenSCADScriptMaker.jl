## - - - - - - - - - - - - - - - - - - - 
export ScadLine
mutable struct ScadLine
    # src
    src::String
    pref::String
    suff::String

    # comment
    comment::String
    
    # formatting
    scope::Int # effect on the scope (-1, 0, +1)
    pad::Int # inline commnet pad (for pretty printing)
    indent::String

    ScadLine(src::String, comment::String, scope::Int = 0) = 
        new(src, "", "", comment, scope, 0, "")
    ScadLine(src::String, scope::Int = 0) = ScadLine(src, "", scope)
    ScadLine() = ScadLine("", "", 0)
end

## - - - - - - - - - - - - - - - - - - - 
import Base.show
show(io::IO, l::ScadLine) = print(io, "ScadLine: ", scad_source(l))

const SCAD_TAB = "   "

## - - - - - - - - - - - - - - - - - - - 
# scad source
function scad_source(l::ScadLine)
    _cmt = isempty(l.comment) ? "" : string(" // ", l.comment)
    _src = string(l.indent, l.pref, l.src, l.suff)
    _src = rpad(_src, l.pad)
    return string(_src, _cmt)
end

## - - - - - - - - - - - - - - - - - - - 
# _scad_literal
_scad_literal(n::Number) = string(round(float(n); digits = 3))
_scad_literal(b::Bool) = b ? "true" : "false"
_scad_literal(p::Pair) = string(first(p), " = ", _scad_literal(last(p)))
_scad_literal(s::Symbol) = string(s)
_scad_literal(s::String) = string("\"", s, "\"")

## - - - - - - - - - - - - - - - - - - - 
export scad_source!
function scad_source!(lines::Vector{ScadLine}; 
        format = false
    )
    isempty(lines) && return ""
    if format
        _flat_indent!(lines)
        _add_indent!(lines)
        _pad!(lines)
    end

    src = join(map(scad_source, lines), "\n")
    return src
end

## - - - - - - - - - - - - - - - - - - - 
# format
function _indents(lines::Vector{ScadLine})
    _scope = 0
    _indents = Int[]
    for line in lines
        line.scope == -1 && (_scope += line.scope)
        # _push!(_indents, _scope)
        push!(_indents, _scope)
        line.scope == 1 && (_scope += line.scope)
    end
    _indents
end

function _add_indent!(lines::Vector{ScadLine}, tab = SCAD_TAB)
    ntabs = _indents(lines)
    for (n, line) in zip(ntabs, lines)
        n = max(n, 0)
        # line.src = string(tab^n, line.src)
        line.indent = string(tab^n)
    end
    lines
end

function _pad!(lines::Vector{ScadLine}; margin = 3)
    _pad = maximum(
        sum([length(l.indent), length(l.pref), length(l.src), length(l.suff)])
        for l in lines
    ) + margin
    for line in lines
        # line.src = rpad(line.src, _pad)
        line.pad = _pad
    end
end

function _flat_indent!(lines)
    for line in lines
        # line.src = strip(line.src)
        line.indent = ""
    end
end
