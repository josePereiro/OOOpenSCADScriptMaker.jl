export scad_openscope
scad_openscope(; scope = +1, kwargs...) = scad_line("{"; scope, kwargs...)
export scad_closescope
scad_closescope(; scope = -1, kwargs...) = scad_line("}"; scope, kwargs...)
