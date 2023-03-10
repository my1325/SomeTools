# frozen_string_literal: true

require 'line'
require 'oc_method'
require 'document'
require 'oc_property'

class OCClass < Line
  def self.class?(line)
    line.strip =~ /^@interface .*:.*$/
  end

  def self.class_extension?(line)
    line.strip =~ /^@interface .*:.*$/
  end

  def self.class_category?(line)
    line.strip =~ /^@interface .*:.*$/
  end

  def initialize(file, line, options = nil)
    unless OCClass.class?(line) || OCClass.class_extension?(line) || OCClass.class_category?(line)
      raise "#{line} is not valid objective class format"
    end

    super(line)
    @options = options
    @lines = []
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
    line = @line
    until Line.end?(line) || file.eof?
      if (line.strip.empty? && !@options[:trim_empty_line]) || (Line.mark?(line.strip) && !@options[:trim_mark])
        @lines.append(Line.new(line))
      elsif Document.document?(line)
        document = Document.new(file, line, @options)
        @document.append(document) unless @options[:trim_document] == true
      elsif OCDefine.define? line.strip
        @lines.append(OCDefine.new(file, line))
      elsif OCDefine.undefine? line
        @lines.append(Line.new(''))
      elsif OCProperty.property? line
        @properties.append(OCProperty.new(file, line))
      elsif OCMethod.instance_method?(line) || OCMethod.class_method?(line)
        @methods.append(OCMethod.new(file, line, @options))
      elsif OCCondition.condition? line
        @lines.append(OCCondition.new(file, line))
      else
        @lines.append Line.new(line)
      end
      line = file.readline unless file.eof?
    end
    @lines.append(Line.new(line)) if Line.end?(line)
  end

  def class_name
    r = /(?<=@interface )[^:, ,<,{,(]*/
    res = r.match @line
    res[0]
  end

  def format_line
    property_line = @properties.shuffle.map(&:format_line).join
    method_line = @methods.shuffle.map(&:format_line).join
    document_line = @document.shuffle.map(&:format_line).join
    lines = @lines.map(&:format_line)
    lines.insert -2, document_line
    lines.insert -2, method_line
    lines.insert -2, property_line
    lines.join
  end
end
