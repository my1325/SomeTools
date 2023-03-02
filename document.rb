# frozen_string_literal: true

class Document < Line

  def self.document?(line)
    line.strip.start_with?("//") || (line.strip.start_with?("/*") && line.strip.end_with?("*/")) || (line.strip.start_with?("/*") && !line.strip.include?("*/"))
  end

  def self.has_document?(line)
    document?(line) || line =~ /.*\/\*.*\*\/.*/
  end

  def self.trim_document(line)
    return "/*" if (line.strip.start_with?("/*") && !line.strip.include?("*/"))
    return "" if document?(line)
    line.gsub(/.*\/\*.*\*\/.*/, "")
    line.gsub(/(\/\/).*/, "")
  end

  def initialize(file, line, options = nil)
    super(line)
    @lines = [Line.new(line)]
    parse_document file, options
  end

  def parse_document(file, options)
    return unless Document.document? @line
    line = file.readline unless file.eof?
    document_start = @line.start_with?("/*")

    while line && !file.eof?
      if line.strip.empty? && options[:trim_empty_line]
        line = file.readline
        next
      end
      document_start = true if line.strip.start_with?("/*")
      document_start = false if line.strip.end_with?("*/")
      if line.strip.start_with?("//") || document_start || line.strip.end_with?("*/")
        @lines.append Line.new(line)
        line = file.readline unless file.eof?
      elsif Line.property? line
        @lines.append OCProperty.new(file, line)
        break
      elsif Line.class_method?(line) || Line.instance_method?(line)
        @lines.append OCMethod.new(file, line, options)
        break
      else
        break
      end
    end
  end

  def format_line
    @lines.map { |line| line.format_line }.join
  end
end
