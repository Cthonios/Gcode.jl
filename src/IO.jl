function axis_pattern(axis)
# g0_g1_pattern = r"G0{1,2}1?(?:\s+X(?<X>[+-]?\d*\.?\d*))?(?:\s+Y(?<Y>[+-]?\d*\.?\d*))?(?:\s+Z(?<Z>[+-]?\d*\.?\d*))?(?:\s+F(?<F>[+-]?\d*\.?\d*))?"
  # return "(?:\\s+$(axis)(?<$(axis)>[+-]?\\d*\\.?\\d*))"
  return "(?:\\s+$(axis)(?<$(axis)>[+-]?\\d*\\.?\\d*))?"
end

function gcode_pattern(gcode, axes)
  pattern = gcode
  for ax in axes
    pattern = pattern * axis_pattern(ax)
  end
  return Regex(pattern)
end

function load_file(file_name::String; axes=['X', 'Y', 'Z', 'E', 'F'])
  # with comments
  first_pattern = r"^(?:[GMTXYZFESAB][+-]?\d*\.?\d*\s*)*(?:\([^\)]*\)|;.*)?$"
  # axes_pattern = gcode_pattern("", axes)
  axes_pattern = gcode_pattern("G(\\d+)", axes)
  axes = tuple(Symbol.(axes)...)
  # axis_patter = gcode_
  # without comments
  # gcode_pattern = r"^(?:[GMTXYZFES][+-]?\d*\.?\d*\s*)*$"
  # gcode_pattern = r"^(?:[GMTXYZFES][+-]?\d*\.?\d*\s*)*(?=\s*(;|\(|$))?"
  open(file_name, "r") do f
    lines = readlines(f)
    # commands = GCodeCommand[]
    commands = []
    for line in lines
      # skip empty lines
      line = strip(line)  # Remove leading/trailing whitespace
      if isempty(line) || startswith(line, ";") || startswith(line, "(")
        # Skip empty lines and comments
        continue
      end

      # m = match(r"^(?:[GMTXYZFES][+-]?\d*\.?\d*\s*)*(?:\([^\)]*\)|;.*)?$", line)
      m_temp = match(first_pattern, line)
      
      if occursin(r"G(\d+)", m_temp.match)
        m = match(r"G(\d+)", m_temp.match)
        if length(m.captures) > 1
          @assert false "Currently unsupported"
        end
        gcode = GcodeCommand(m_temp.match, axes, axes_pattern)
        push!(commands, gcode)
      elseif occursin(r"M(\d+)", m_temp.match)
        # @show "M code"
      end
    end
    commands
  end
  # commands
end
