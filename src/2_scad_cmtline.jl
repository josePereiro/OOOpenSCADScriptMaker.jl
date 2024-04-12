export scad_comment
function scad_comment(cmt::String) 
    _cmtstr = string("// ", cmt)
    return [ScadLine(_cmtstr, "", 0)]
end