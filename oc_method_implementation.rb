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
    count = -1
    loop do
      count += line.strip.count('{')
      count -= line.strip.count('}')
      @lines.append(Line.new(line))
      break if count.zero?

      line = file.readline
    end
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
