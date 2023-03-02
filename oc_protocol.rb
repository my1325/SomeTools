# frozen_string_literal: true

class OCProtocol < Line
  def self.protocol?(line)
    line =~ /^@protocol .*(?<!;)$/
  end

  def initialize(file, line, options)
    super(line)
    @optional = [Line.new("@optional")]
    @required = [Line.new("@required")]
    @lines = [Line.new(line)]
    parse_protocol file, options
  end

  def parse_protocol(file, options)
    line = file.readline
    is_required = true
    until Line.end? line
      if line.strip.empty? && options[:trim_empty_line]
        line = file.readline
        next
      end

      if Line.mark? line.strip && options[:trim_mark]
        line = file.readline
        next
      end

      if line.strip.start_with? '@required'
        is_required = true
      elsif line.strip.start_with? '@optional'
        is_required = false
      elsif Document.document?(line) && !options[:trim_document]
        @required.append(Document.new file, line, options) if is_required
        @optional.append(Document.new file, line, options) unless is_required
      elsif OCProperty.property? line
        @required.append(OCProperty.new file, line) if is_required
        @optional.append(OCProperty.new file, line) unless is_required
      elsif OCMethod.instance_method?(line) || OCMethod.class_method?(line)
        @required.append(OCMethod.new file, line, options) if is_required
        @optional.append(OCMethod.new file, line, options) unless is_required
      end

      @required.append Line.new(line) if is_required
      @optional.append Line.new(line) unless is_required
      line = file.readline
    end

    @lines.append(Line.new line)
  end

  def protocol_name
    r = /(?<=@protocol )[^ ,<]*/
    r.match(@line.line)[0]
  end

  def format_line
    required_line = @required.shuffle
    optional_line = @optional.shuffle
    @lines.insert -2, optional_line
    @lines.insert -2, required_line
    @lines.map { |line| line.format_line }.join
  end
end
