# frozen_string_literal: true

class Line
  def self.protocol?(line)
    OCProtocol.protocol? line
  end

  def self.mark?(line)
    line.start_with?('#pragma mark')
  end

  def self.include_document?(line)
    Document.include_document? line
  end

  def self.class?(line)
    OCClass.class? line
  end

  def self.class_imp?(line)
    line.start_with? '@implementation'
  end

  def self.class_extension?(line)
    OCClass.class_extension? line
  end

  def self.class_category_imp?(line)
    line =~ /^@implementation .*\(.*\)$/
  end

  def self.class_category?(line)
    OCClass.class_category? line
  end

  def self.instance_method?(line)
    OCMethod.instance_method? line
  end

  def self.class_method?(line)
    OCMethod.class_method? line
  end

  def self.instance_method_imp?(line)
    line =~ /^- ?\(.*\).*(?<!;)$/
  end

  def self.class_method_imp?(line)
    line =~ /^\+ ?\(.*\).*(?<!;)$/
  end

  def self.property?(line)
    OCProperty.property? line
  end

  def self.end?(line)
    ['@end', "@end\n"].include?(line)
  end

  def initialize(line)
    @line = line
  end

  attr_reader :line

  def format_line
    @line
  end
end
