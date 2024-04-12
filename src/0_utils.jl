# ## - - - - - - - - - - - - - - - - - - - 
# _push!(_) = nothing
# _push!(col, a) = push!(col, a)
# _push!(col, a, args...) = push!(col, a, args...)

## - - - - - - - - - - - - - - - - - - - 
# Append comments
_comment_vec(c::String) = String[c]
_comment_vec(c::Vector) = c

function _append_comment!(lines::Vector, comment)
    for (_ln, _cmt) in zip(lines, _comment_vec(comment))
        _ln.comment = string(_ln.comment, _cmt)
    end
    return lines
end