# frozen_string_literal: true

class OCCondition < Line
  def self.condition?(line)
    line.strip.start_with?('#if')
  end

  def self.condition_end?(line)
    line.strip.start_with?('#endif')
  end

  def self.condition_else_or_elseif?(line)
    line.strip.start_with?('#else') || line.strip.start_with?('#elif')
  end

  def initialize(file, line)
    super(line)
    @lines = []
    @max_parenthesis_count = 0
    parse_condition file, line
  end

  def max_parenthesis_count
    inner_count = @lines.filter { |line| line.class == OCCondition }
          .reduce(0) { |i, line| i + line.max_parenthesis_count }
    @max_parenthesis_count + inner_count
  end

  def parse_condition(file, line)
    parenthesis_count = 0
    line_start = false
    until OCCondition.condition_end? line
      if OCCondition.condition?(line) && line_start
        @lines.append(OCCondition.new(file, line))
      elsif OCCondition.condition_else_or_elseif? line
        @max_parenthesis_count = [@max_parenthesis_count, parenthesis_count].min if parenthesis_count < 0
        @max_parenthesis_count = [@max_parenthesis_count, parenthesis_count].max if parenthesis_count > 0
        parenthesis_count = 0
        @lines.append(Line.new(line))
      else
        parenthesis_count += OCMethodImplementation.count_char(line,'{')
        parenthesis_count -= OCMethodImplementation.count_char(line,'}')
        @lines.append(Line.new(line))
      end
      line_start = true
      line = file.readline
    end
    @lines.append(Line.new(line)) if OCCondition.condition_end?(line)
    @max_parenthesis_count = [@max_parenthesis_count, parenthesis_count].min if parenthesis_count < 0
    @max_parenthesis_count = [@max_parenthesis_count, parenthesis_count].max if parenthesis_count > 0
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
