for funsym in [
        :scad_comment, 
        :scad_variable, 
        :scad_call, 
        :scad_mlcall, 
        :scad_newline, 
        :scad_openscope,
        :scad_closescope, 
        :scad_line
    ]

    funsym! = Symbol(string(funsym, "!"))
    @eval begin
        export $(funsym!)
        function $(funsym!)(ls::Vector{ScadLine}, args...; kwargs...) 
            _ls = $(funsym)(args...; kwargs...)
            push!(ls, _ls...)
            return ls
        end
    end
end