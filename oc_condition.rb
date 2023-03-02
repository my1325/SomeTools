# frozen_string_literal: true

class OCCondition < Line
  def self.condition?(line)
    line.strip.start_with?('#if')
  end

  def self.condition_end?(line)
    line.strip.start_with?('#endif')
  end

  def initialize(file, line)
    super(line)
    @lines = []
    parse_condition file, line
  end

  def parse_condition(file, line)
    until OCCondition.condition_end? line
      @lines.append(Line.new(line))
      line = file.readline
    end
    @lines.append(Line.new(line))
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
