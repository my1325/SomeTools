# frozen_string_literal: true

class OCMethod < Line
  def self.instance_method?(line)
    line_strip = Document.trim_document line
    line_strip.strip =~ /^- ?\(.*\).*$/
  end

  def self.class_method?(line)
    line_strip = Document.trim_document line
    line_strip =~ /^\+ ?\(.*\).*$/
  end

  def initialize(file, line, options = nil)
    super(line)
    @lines = []
    parse_method file, options
  end

  def parse_method(file, options)
    line = @line
    until line.strip.end_with?(';') || Document.trim_document(line).strip.end_with?(';')
      @lines.append(Line.new(line))
      line = file.readline unless file.eof?
    end
    @lines.append(Line.new(line))
  end

  def class_name
    r = /(?<=\))[^:]*/
    r.match(@line).join(':')
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
