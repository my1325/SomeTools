# frozen_string_literal: true

require 'line'
require 'oc_method'
require 'document'
require 'oc_property'

class OCClass < Line
  def self.class?(line)
    line =~ /^@interface .*:.*$/
  end

  def self.class_extension?(line)
    line =~ /^@interface .*\(\)$/
  end

  def self.class_category?(line)
    line =~ /^@interface .*\(.*\)$/
  end

  def initialize(file, line, options = nil)
    raise "#{line} is not valid objective class format" unless OCClass.class?(line) || OCClass.class_extension?(line) || OCClass.class_category?(line)
    super(line)
    @options = options
    @lines = [Line.new(line)]
    @properties = []
    @methods = []
    @document = []
    parse_line file
  end

  def category?
    OCClass.class_category? @line
  end

  def class?
    OCClass.class? @line
  end

  def extension?
    OCClass.class_extension? @line
  end

  def parse_line(file)
    if @line.strip.end_with? '{'
      @lines.append(OCClassInstance.new file, @line, @options)
    end

    line = file.readline
    until Line.end?(line) || file.eof?
      if line.strip.empty? && @options[:trim_empty_line]
        line = file.readline
        next
      end

      if Line.mark?(line.strip) && @options[:trim_mark]
        line = file.readline
        next
      end

      if line.strip.start_with? '{'
        @lines.append(OCClassInstance.new file, line, @options)
      elsif Document.document?(line) && !@options[:trim_document]
        @document.append(Document.new file, line, @options)
      elsif OCProperty.property? line
        @properties.append(OCProperty.new file, line)
      elsif OCMethod.instance_method?(line) || OCMethod.class_method?(line)
        @methods.append(OCMethod.new file, line, @options)
      else
        @lines.append Line.new(line)
      end
      line = file.readline unless file.eof?
    end
    @lines.append Line.new(line)
  end

  def class_name
    r = /(?<=@interface )[^:, ,<,{,(]*/
    res = r.match @line
    res[0]
  end

  def format_line
    property_line = @properties.shuffle.map { |line| line.format_line }.join
    method_line = @methods.shuffle.map { |line| line.format_line }.join
    document_line = @document.shuffle.map { |line| line.format_line }.join
    lines = @lines.map { |line| line.format_line }
    lines.insert -2, document_line
    lines.insert -2, method_line
    lines.insert -2, property_line
    lines.join
  end
end
