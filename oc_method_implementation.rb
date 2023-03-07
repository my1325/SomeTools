# frozen_string_literal: true

class OCMethodImplementation < Line
  def self.class_method_implementation?(line)
    line.strip =~ /^\+ ?\(.*\).*(?<!;)$/
  end

  def self.instance_method_implementation?(line)
    line.strip =~ /^- ?\(.*\).*(?<!;)$/
  end

  def self.count_char(line, char)
    strip_line = line.strip
                     # .gsub(/[". '].*[", ']/, '')
    strip_line.count(char)
  end

  def initialize(file, line, options)
    super(line)
    @lines = []
    parse_method_implementation file, line, options
  end

  def parse_method_implementation(file, line, options)
    count = 0
    method_begin = false
    loop do
      break if file.eof? || count.zero? && method_begin
      if OCCondition.condition? line
        oc_condition = OCCondition.new(file, line)
        count += oc_condition.max_parenthesis_count
        @lines.append(oc_condition)
      elsif OCDefine.undefine? line
        @lines.append(Line.new(''))
      else
        count += OCMethodImplementation.count_char(line, '{')
        method_begin = true unless count.zero?
        count -= OCMethodImplementation.count_char(line,'}')
        @lines.append(Line.new(line))
      end
      line = file.readline unless file.eof? || (count.zero? && method_begin)
    end
    # @lines.append(Line.new(line)) if count.zero?
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
