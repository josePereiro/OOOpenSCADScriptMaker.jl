# OOOpenSCADScriptMaker

A package for creating OpenSCAD scripts. This package do not check for the correctness of the scripts, it just provide an 'useful' interface for other packages to convert custom objects to OpenSCAD code.

## Scad script line structure

```julia
let
    # Each line has the follow structure
    ls = scad_line("__SRC_TEXT__+"; 
        pref = "__PREFIX__+", 
        suff = "__SUFFIX__", 
        comment = "__INLINE_COMMENT__"
    )
    # Compile to:
    # __PREFIX__+__SRC_TEXT__+__SUFFIX__ // __INLINE_COMMENT__

    # compile source
    src = scad_source!(ls; format = false)
    println(src)
end
```

## Script example

This example shows a complete flow to create a `.scad` file.

```julia
let
    # The script is contructed line by line
    ls = ScadLine[]

    # The bang version of each method push! the new line(s) to an array
    scad_comment!(ls, "This is a comment line")
    # Compile to:
    # // This is a comment line

    scad_variable!(ls, "bla", "string"; comment = "a variable line")
    scad_variable!(ls, "\$fn", 60; comment = "magic variables")
    scad_line!(ls, ""; comment = "an empty line")
    # Compile to:
    # bla = "string";                      // a variable line
    # $fn = 60.0;                          // magic variables
    #                                      // an empty line

    
    scad_newline!(ls)
    scad_comment!(ls, "A simple call")
    scad_call!(ls, "cube", [1,1,1]; suff = ";", comment = "positional arguments")
    scad_call!(ls, "cube", "size" => [1,1,1]; suff = ";", comment = "key-value arguments")
    scad_call!(ls, "sphere", "d" => 5; pref = "!", suff = ";", comment = "dev preffix")
    # Compile to:
    # 
    # // A simple call                    
    # cube([1.0, 1.0, 1.0]);               // positional arguments
    # cube(size = [1.0, 1.0, 1.0]);        // key-value arguments
    # !sphere(d = 5.0);                    // dev preffix

    scad_newline!(ls)
    scad_comment!(ls, "Calls with children (scope)")
    scad_call!(ls, "translate", [1,1,1])
    scad_openscope!(ls; comment = "Note the scoped indentation")
        scad_call!(ls, 
            "cylinder", "d" => :bla, "\$fn" => 60,
            suff = ";", 
            comment = "pass variables as Symbols"
        )
    scad_closescope!(ls; suff = ";")
    # Compile to:
    #                                    
    # // Calls with children (scope)      
    # translate([1.0, 1.0, 1.0])          
    # {                                    // Note the scoped indentation
    #    cylinder(d = bla, $fn = 60.0);    // pass variables as Symbols
    # };                                  
    
    scad_newline!(ls)
    scad_comment!(ls, "for loops are also calls")
    scad_call!(ls, "for", "i" => 1:0.5:10; comment = "ranges work")
    scad_openscope!(ls)
        scad_call!(ls, 
            "cylinder", "d" => :i, "\$fn" => 60,
            suff = ";", 
        )
    scad_closescope!(ls; suff = ";")
    # Compile to:
    #
    # // for loops are also calls         
    # for(i = [1.0:0.5:10.0])              // ranges work
    # {                                   
    #    cylinder(d = i, $fn = 60.0);     
    # };       

    scad_newline!(ls)
    scad_comment!(ls, "Multiline calls")
    scad_comment!(ls, "you can pass a comment array")
    scad_mlcall!(ls, 
        "cube", [1,2,3], "center" => true; 
        suff = ";", 
        comment = string.(["cmt"], 1:10)
    )
    # Compile to:
    #                                    
    # // Multiline calls                  
    # // you can pass a comment array     
    # cube(                                // cmt1
    #    [                                 // cmt2
    #       1.0,                           // cmt3
    #       2.0,                           // cmt4
    #       3.0,                           // cmt5
    #    ],                                // cmt6
    #    center = true                     // cmt7
    # );                                   // cmt8

    # compile source
    src = scad_source!(ls; format = true)
    println(src)
    
    # write to a scad document
    fn = joinpath(@__DIR__, string(basename(@__FILE__), ".scad"))
    open(fn, "w") do io
        write(io, src);
    end
    nothing
end
```

## TODOs

[ ] Add tests