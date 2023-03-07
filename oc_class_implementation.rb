# frozen_string_literal: true
require 'oc_method_implementation'
class OCClassImplementation < Line
  def self.implementation?(line)
    line.strip.start_with? '@implementation'
  end

  def self.category_implementation?(line)
    line.strip.start_with? '@implementation'
  end

  def initialize(file, line, options)
    super(line)
    @lines = []
    @methods = []
    @document = []
    parse_implementation file, line, options
  end

  def parse_implementation(file, line, options)
    until Line.end?(line) || file.eof?
      if (line.strip.empty? && options[:trim_empty_line] == false) || (Line.mark?(line.strip) && options[:trim_mark] == false)
        @lines.append(Line.new(line))
      elsif Document.document?(line)
        document = Document.new(file, line, options)
        @document.append(document) unless options[:trim_document] == true
      elsif OCMethodImplementation.class_method_implementation?(line) || OCMethodImplementation.instance_method_implementation?(line)
        @methods.append(OCMethodImplementation.new(file, line, options))
      elsif OCDefine.define? line.strip
        @lines.append(OCDefine.new(file, line))
      elsif OCDefine.undefine? line
        @lines.append(Line.new(''))
      elsif OCCondition.condition? line
        @lines.append(OCCondition.new(file, line))
      else
        @lines.append(Line.new(line))
      end
      line = file.readline unless file.eof?
    end
    @lines.append(Line.new(line)) if Line.end?(line)
  end

  def format_line
    method_line = @methods.shuffle.map(&:format_line).join
    document_line = @document.shuffle.map(&:format_line).join
    lines = @lines.map(&:format_line)
    lines.insert -2, document_line
    lines.insert -2, method_line
    lines.join
  end
end
