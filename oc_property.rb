# frozen_string_literal: true

class OCProperty < Line
  def self.property?(line)
    line =~ /^@property.*;$/
  end

  def initialize(file, line)
    super(line)
  end

  def property_name
    r = /(?<= )[^ ;]*/
    res = r.match(@line.line)
    i = res.count
    i -= 1 until i < 0 || !res[i].empty?
    i >= 0 ? res[i] : res[-1]
  end
end
