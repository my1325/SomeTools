# frozen_string_literal: true

class OCMethod < Line
  def self.instance_method?(line)
    line =~ /^- ?\(.*\).*$/
  end

  def self.class_method?(line)
    line =~ /^\+ ?\(.*\).*$/
  end

  def initialize(file, line, options = nil)
    super(line)
    @lines = [Line.new(line)]
    parse_method file, options
  end

  def parse_method(file, options)
    return if @line.strip.end_with?(";")
    line = file.readline
    until line.strip.end_with?(";")
      if Document.document?(line) && options[:trim_document]
        line = file.readline
        next
      end

      @lines.append(Line.new line)
      line = file.readline
    end

    @lines.append(Line.new line)
  end

  def class_name
    r = /(?<=\))[^:]*/
    r.match(@line).join(":")
  end

  def format_line
    @lines.map { |line| line.format_line }.join
  end
end
