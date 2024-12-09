struct Comment <: AbstractCommand
  val::String
end

# struct GcodeCommand{N} <: AbstractCommand
struct GcodeCommand{T} <: AbstractCommand
  # gcodes::NTuple{N, Int32}
  gcode::Int32
  # axes::NTuple{N, Char}
  # vals::NTuple{N, Float32}
  # axes::Vector{Char}
  # vals::Vector{Float32}
  # vals::Dict{Char, Float32}
  # vals::NamedTuple{S}
  vals::T
  # comment::String
end

# function GcodeCommand(line, gcode, axes)
function GcodeCommand(line, axes, axes_pattern)
  m = match(axes_pattern, line)
  gcode = m.captures[1]
  vals = @views map(x -> x === nothing ? Float32(0.) : parse(Float32, x), m.captures[2:end])
  gcode = parse(Int32, gcode)
  vals = NamedTuple{axes}(vals)
  # return GcodeCommand(gcode, axes, vals, "")
  return GcodeCommand(gcode, vals)
  # vals
  # vals
end
