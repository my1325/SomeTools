# frozen_string_literal: true

class OCProtocol < Line
  def self.protocol?(line)
    line =~ /^@protocol .*(?<!;)$/
  end

  def initialize(file, line, options)
    super(line)
    @optional = [Line.new('@optional\n')]
    @required = [Line.new('@required\n')]
    @lines = [Line.new(line)]
    parse_protocol file, options
  end

  def parse_protocol(file, options)
    line = file.readline
    is_required = true
    until Line.end?(line) || file.eof?
      if line.strip.start_with? '@required'
        is_required = true
      elsif line.strip.start_with? '@optional'
        is_required = false
      elsif (line.strip.empty? && !options[:trim_empty_line]) || (Line.mark?(line.strip) && !options[:trim_mark])
        @required.append(Line.new(line)) if is_required
        @optional.append(Line.new(line)) unless is_required
      elsif Document.document?(line)
        unless options[:trim_document] == true
          @required.append(Document.new(file, line, options)) if is_required
          @optional.append(Document.new(file, line, options)) unless is_required
        end
      elsif OCProperty.property? line
        @required.append(OCProperty.new(file, line)) if is_required
        @optional.append(OCProperty.new(file, line)) unless is_required
      elsif OCMethod.instance_method?(line) || OCMethod.class_method?(line)
        @required.append(OCMethod.new(file, line, options)) if is_required
        @optional.append(OCMethod.new(file, line, options)) unless is_required
      elsif OCCondition.condition? line
        @required.append(OCCondition.new(file, line)) if is_required
        @optional.append(OCCondition.new(file, line)) unless is_required
      else
        @required.append Line.new(line) if is_required
        @optional.append Line.new(line) unless is_required
      end
      line = file.readline unless file.eof?
    end

    @lines.append(Line.new(line))
  end

  def protocol_name
    r = /(?<=@protocol )[^ ,<]*/
    r.match(@line)[0]
  end

  def format_line
    required_line = @required.shuffle.map(&:format_line).join
    optional_line = @optional.shuffle.map(&:format_line).join
    lines = @lines.map(&:format_line)
    lines.insert -2, optional_line
    lines.insert -2, required_line
    lines.join
  end
end
