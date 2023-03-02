# frozen_string_literal: true

class OCMethodImplementation < Line
  def self.class_method_implementation?(line)
    line =~ /^+ ?\(.*\).*(?<!;)$/
  end

  def self.instance_method_implementation?(line)
    line =~ /^- ?\(.*\).*(?<!;)$/
  end

  def initialize(file, line, options)
    super(line)
    @lines = []
    parse_method_implementation file, line, options
  end

  def parse_method_implementation(file, line, options)
    count = 0
    method_begin = false
    loop do
      count += line.strip.count('{')
      count -= line.strip.count('}')
      break if count.zero? && method_begin

      method_begin = true unless count.zero?
      @lines.append(Line.new(line))
      line = file.readline
    end
    @lines.append(Line.new(line))
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
