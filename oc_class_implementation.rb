# frozen_string_literal: true
require 'oc_method_implementation'
class OCClassImplementation < Line
  def self.implementation?(line)
    line.strip.start_with? '@implementation'
  end

  def self.category_implementation?(line)
    line =~ /^@implementation .*\(.*\)$/
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
      if (line.strip.empty? && !options[:trim_empty_line]) || (Line.mark?(line.strip) && !options[:trim_mark])
        @lines.append(Line.new(line))
      elsif Document.document?(line)
        @document.append(Document.new(file, line, options)) unless options[:trim_document] == true
      elsif OCMethodImplementation.class_method_implementation?(line) || OCMethodImplementation.instance_method_implementation?(line)
        @methods.append(OCMethodImplementation.new(file, line, options))
      elsif OCCondition.condition? line
        @lines.append(OCCondition.new(file, line))
      else
        @lines.append(Line.new(line))
      end
      line = file.readline unless file.eof?
    end
    @lines.append(Line.new(line))
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
