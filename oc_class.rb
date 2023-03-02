# frozen_string_literal: true

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
    @lines = [Line.new line]
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
    if @line.line.strip.end_with? '{'
      @lines.append(OCClassInstance.new file, @line.line, @options)
    end

    line = file.readline
    until Line.end? line
      if line.strip.empty? && @options[:trim_empty_line]
        line = file.readline
        next
      end

      if Line.mark? line.strip && @options[:trim_mark]
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
      line = file.readline
    end
    @lines.append Line.new(line)
  end

  def class_name
    r = /(?<=@interface )[^:, ,<,{,(]*/
    res = r.match @line
    res[0]
  end

  def format_line
    property_line = @properties.shuffle
    method_line = @methods.shuffle
    document_line = @document.shuffle
    @lines.insert -2, document_line
    @lines.insert -2, method_line
    @lines.insert -2, property_line
    @lines.map { |line| line.format_line }.join
  end
end
