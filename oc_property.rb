# frozen_string_literal: true

class OCProperty < Line
  def self.property?(line)
    line.strip =~ /^@property.*$/
  end

  def initialize(file, line)
    super(line)
    @lines = []
    parse_property file, line
  end

  def parse_property(file, line)
    until line.strip.end_with?(';') || Document.trim_document(line).strip.end_with?(';')
      @lines.append(Line.new(line))
      line = file.readline
    end
    @lines.append(Line.new(Document.trim_document(line)))
  end

  def property_name
    r = /(?<= )[^ ;]*/
    res = r.match(@line)
    i = res.count
    i -= 1 until i.negative? || !res[i].empty?
    i >= 0 ? res[i] : res[-1]
  end

  def format_line
    @lines.map(&:format_line).join
  end
end
