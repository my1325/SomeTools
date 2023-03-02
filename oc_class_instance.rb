# frozen_string_literal: true

class OCClassInstance < Line

  def initialize(file, line, options = nil)
    super(line)
    @lines = []
    parse_instance_lines file, line, options
  end

  def parse_instance_lines(file, line, options)
    until line.strip.end_with? '}'
      if line.strip.empty? && @options[:trim_empty_line]
        line = file.readline
        next
      end

      if Line.mark? line.strip && @options[:trim_mark]
        line = file.readline
        next
      end

      if Document.document?(line) && !@options[:trim_document]
        @lines.append(Document.new file, line, options)
      else
        @line.append(Line.new line)
      end

      line = file.readline
    end
    @lines.append(Line.new line)
  end

  def format_line
    @lines.map { |line| line.format_line }.join
  end
end
