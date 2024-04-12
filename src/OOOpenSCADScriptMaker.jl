## ---.-... -.--. -.-.-. - . --..--..-- 
# OOOpenSCADScriptMaker
# - Make a julia package that literally which implements a very literal
# scad interface... 
# - Almost as writing an string, but with the tipical scad structure
# Ex:
# > scad_variable("bla", 10) 
# Output: "bla = 10;"
# > scad_variable("blo", [10]; comment = "lalala") 
# Output: "blo = [10]; \\ lalala"
# > scad_call("cicle", :d => 10, :_fn => 30; pref = "!") 
# Output: "!circle(d = 10, $fn = 30);"
# > scad_openchild() 
# Output: "{"
# > scad_closechild(; suff = ";") 
# Output: "};"
# > scad_callml("cicle", :d => 10, :_fn => 30; comment = ["cmt1", "cmt2", "cmt2"]) 
# Output: 
# "circle(   \\ cmt1
#   d = 10,  \\ cmt1
#   $fn = 30 \\ cmt1
#);"

module OOOpenSCADScriptMaker

    #! include .
    include("0_utils.jl")
    include("1_ScadLines.jl")
    include("2_scad_call.jl")
    include("2_scad_cmtline.jl")
    include("2_scad_line.jl")
    include("2_scad_newline.jl")
    include("2_scad_scope.jl")
    include("2_scad_variable.jl")
    include("3_bang_interface.jl")
    

end