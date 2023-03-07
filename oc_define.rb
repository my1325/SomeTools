# frozen_string_literal: true

class OCDefine < Line
  def self.define?(line)
    line.strip =~ /^#define .*[\\,;]$/
  end

  def self.undefine?(line)
    line.strip =~ /^#undef .*/
  end

  def initialize(file, line)
    super(line)
    @lines = []
    parse_define file, line
  end

  def parse_define(file, line)
    until line.strip.end_with?(';') || file.eof?
      @lines.append(Line.new(line))
      line = file.readline unless file.eof?
    end
    @lines.append(Line.new(line))
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
