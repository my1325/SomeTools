# frozen_string_literal: true

class Line
  def self.protocol?(line)
    OCProtocol.protocol? line
  end

  def self.mark?(line)
    line.start_with?('#pragma mark')
  end

  def self.end?(line)
    line.strip.end_with?('@end')
  end

  def initialize(line)
    @line = line
  end

  attr_reader :line

  def format_line
    @line
  end
end
