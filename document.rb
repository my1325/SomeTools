# frozen_string_literal: true

class Document < Line

  def self.document?(line)
    line.strip.start_with?('//') ||
      (line.strip.start_with?('/*') && line.strip.end_with?('*/')) ||
      (line.strip.start_with?('/*') && !line.strip.include?('*/'))
  end

  def self.include_document?(line)
    document?(line) || line =~ %r{.*/\*.*\*/.*}
  end

  def self.trim_document(line)
    return '/*' if line.strip.start_with?('/*') && !line.strip.include?('*/')
    return '' if document?(line)

    line.gsub(%r{.*/\*.*\*/.*}, '')
    line.gsub(%r{(//).*}, '')
  end

  def initialize(file, line, options = nil)
    super(line)
    @lines = []
    if line.strip.start_with?('/*')
      parse_multiline_document file, options
    else
      parse_inline_document
    end
  end

  def parse_inline_document
    @lines.append(Line.new(@line))
  end

  def parse_multiline_document(file, options)
    line = @line
    until line.strip.end_with?('*/') || file.eof?
      @lines.append(Line.new(line))
      line = file.readline
    end
    @lines.append(Line.new(line))
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
