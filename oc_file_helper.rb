# frozen_string_literal: true

class OCFileHelper
  def initialize(file)
    @file = file
  end

  def header?
    File.basename(@file).end_with? '.h'
  end

  def imp?
    File.basename(@file) =~ /.*\.m(\+\+)?$/
  end

  def protocol?(line)
    line =~ /^@protocol .*(?<!;)$/
  end

  def class?(line)
    line =~ /^@interface .*:.*$/
  end

  def class_imp?(line)
    line.start_with? '@implementation'
  end

  def class_extension?(line)
    line =~ /^@interface .*\(\)$/
  end

  def class_category_imp?(line)
    line =~ /^@implementation .*\(.*\)$/
  end

  def class_category?(line)
    line =~ /^@interface .*\(.*\)$/
  end

  def has_document?(line)
    line =~ /.*\/\*.*\*\/.*/
  end

  def instance_method?(line)
    line =~ /^- ?\(.*\).*$/
  end

  def class_method?(line)
    line =~ /^\+ ?\(.*\).*$/
  end

  def instance_method_imp?(line)
    line =~ /^- ?\(.*\).*(?<!;)$/
  end

  def class_method_imp?(line)
    line =~ /^\+ ?\(.*\).*(?<!;)$/
  end

  def property?(line)
    line =~ /^@property.*;$/
  end

  def end?(line)
    line == '@end' || line == "@end\n"
  end

  def could_parse_file?
    header? || imp?
  end

  def parse_file
    new_file_path = File.join File.dirname(@file), "#{File.basename(@file)}_temp"
    File.open new_file_path, 'w+' do |new_file|
      File.open @file do |file|
        line = file.readline.strip
        while line
          new_line = line.concat("\n")
          if protocol? line
            new_line = parse_protocol file, line
          elsif class?(line) || class_extension?(line) || class_category?(line)
            new_line = parse_class file, line
          elsif class_imp?(line) || class_category_imp?(line)
            new_line = parse_class_imp file, line
          elsif has_document? line
            new_line = line.gsub /\/\*.*\*\//, ''
          elsif line.include?('/*')
             new_line = parse_document file, line
          end
          new_file.write new_line unless new_line.strip.start_with?('//')
          if !file.eof?
            line = file.readline.strip
          else
            line = nil
          end
        end
      end
    end
    File.delete @file
    File.rename new_file_path, @file
  end

  def parse_protocol(file, line)
    optional_lines = []
    require_lines = []
    _line = file.readline.strip
    optional = false
    until end?(_line)
      if _line == "\n" || _line.strip.start_with?('//')
        _line = file.readline.strip
        next
      end

      if _line == '@optional'
        optional = true
      elsif _line == '@required'
        optional = false
      elsif optional
        if class_method?(_line) || instance_method?(_line)
          _line = parse_method file, _line
        elsif has_document? _line
          _line = _line.gsub /\/\*.*\*\//, ''
        elsif line.include?('/*')
          _line = parse_document file, _line
        end
        optional_lines.append _line
      else
        if class_method?(_line) || instance_method?(_line)
          _line = parse_method file, _line
        elsif has_document? _line
          _line = _line.gsub /\/\*.*\*\//, ''
        elsif line.include?('/*')
          _line = parse_document file, _line
        end
        require_lines.append _line
      end
      _line = file.readline.strip
    end
    optional_string = "\n@optional\n".dup.concat(optional_lines.shuffle.join("\n"))
    require_string = "\n@required\n".dup.concat(require_lines.shuffle.join("\n"))
    "\n#{line}\n".dup.concat(require_string).concat(optional_string).concat("\n@end\n")
  end

  def parse_document(file, line)
    _line = line.gsub /@".*"/, ''
    return line if _line.include?('/*') == 0
    line = line.gsub /\/\*.*/, ''
    _line = line
    _line = file.readline until _line.include?('*/') || file.eof?
    _line = _line.gsub /.*\*\//, ''
    line.concat(_line)
  end

  def parse_class(file, line)
    lines = []
    _line = file.readline
    until end?(_line)
      if _line == "\n" || _line.strip.start_with?('//')
        _line = file.readline
        next
      end

      new_line = _line
      if instance_method?(_line) || class_method?(_line)
        new_line = parse_method file, _line
      elsif has_document? _line
        new_line = _line.gsub /\/\*.*\*\//, ''
      elsif _line.include?('/*')
        new_line = parse_document file, _line
      end

      lines.append new_line
      _line = file.readline
    end
    "\n#{line}\n".dup.concat(lines.shuffle.join("\n").concat("\n@end\n"))
  end

  def parse_method(file, line)
    lines = []
    until line.strip.end_with? ';'
      lines.append line
      line = file.readline
    end
    lines.join.concat(line)
  end

  def parse_class_imp(file, line)
    lines = []
    method = []
    _line = file.readline
    until end?(_line) || file.eof?
      if _line == "\n" || _line.strip.start_with?("//")
        _line = file.readline unless file.eof?
        next
      end

      if class_method_imp?(_line) || instance_method_imp?(_line)
        method.append(parse_method_imp(file, _line))
      elsif has_document? _line
        new_line = _line.gsub /\/\*.*\*\//, ''
        lines.append(new_line)
      elsif _line.include?('/*')
        new_line = parse_document file, _line
        lines.append(new_line)
      else
        lines.append(_line)
      end
      _line = file.readline unless file.eof?
    end
    "\n#{line}\n".dup.concat(lines.join).concat(method.shuffle.join("\n")).concat("\n@end\n")
  end

  def parse_method_imp(file, line)
    return line if line.end_with?('}')
    lines = []
    count = -1
    until count == 0
      if line == "\n" || line.strip.start_with?('//')
        line = file.readline unless file.eof?
        next
      end

      left_count = line.count('{')
      right_count = line.count('}')
      if left_count - right_count == 0

      elsif count == -1
        count = left_count - right_count
      else
        count += left_count - right_count
      end
      lines.append line
      line = file.readline
    end

    "#{line}".dup.concat(lines.join)
  end
end
