# frozen_string_literal: true

class OCFileHelper
  def initialize(file)
    @file = file
  end

  def header?
    File.basename(@file).end_with? '.h'
  end

  def imp?
    File.basename(@file).end_with? '.m'
  end

  def protocol?(line)
    line =~ /^@protocol .*(?<!;)$/
  end

  def class?(line)
    line =~ /^@interface .*:.*$/
  end

  def class_imp?(line)
    line.start_with? '@implemention'
  end

  def class_extension?(line)
    line =~ /^@interface .*\(\)$/
  end

  def class_category_imp?(line)
    line =~ /^@implemention .*\(.*\)$/
  end

  def class_category?(line)
    line =~ /^@interface .*\(.*\)$/
  end

  def instance_method?(line)
    line =~ /^- ?\(.*\).*;$/
  end

  def class_method?(line)
    line =~ /^+ ?\(.*\).*;$/
  end

  def instance_method_imp?(line)
    line =~ /^- ?\(.*\).*(?<!;)$/
  end

  def class_method_imp?(line)
    line =~ /^+ ?\(.*\).*(?<!;)$/
  end

  def property?(line)
    line =~ /^@property.*;$/
  end

  def end?(line)
    line == '@end'
  end

  def parse_file
    if header?
      parse_header_file
    else
      parse_imp_file
    end
  end

  def parse_header_file
    file = File.new @file
    dir = File.dirname @file
    file_name = File.basename @file
    new_file = File.new(File.join(dir, "#{file_name}_temp"), 'w+')
    line = file.readline
    while line && !file.eof?
      new_line = line
      if protocol? line
        new_line = parse_protocol file, line
      elsif class? line
        new_line = parse_class file, line
      elsif class_extension? line
        new_line = parse_extension file, line
      elsif class_category? line
        new_line = parse_category file, line
      end
      new_file.write new_line
      line = file.readline unless file.eof?
    end
    file.close
    new_file.close
  end

  def parse_protocol(file, line)
    optional_lines = []
    require_lines = []
    _line = file.readline.strip
    optional = false
    until end?(_line)
      continue if _line == '\n'
      if _line == '@optional'
        optional = true
      elsif _line == '@required'
        optional = false
      elsif optional
        optional_lines.append _line
      else
        require_lines.append _line
      end
      _line = file.readline.strip
    end
    optional_string = "\n@optional\n".dup.concat(optional_lines.shuffle.join("\n"))
    require_string = "\n@required\n".dup.concat(require_lines.shuffle.join("\n"))
    "#{line}\n".dup.concat(require_string).concat(optional_string).concat("\n@end")
  end

  def parse_class(file, line)
    lines = []
    _line = file.readline.strip
    until end?(_line)
      continue if _line == '\n'
      lines.append _line
      _line = file.readline.strip
    end
    "#{line}\n".dup.concat(lines.shuffle.join("\n").concat("\n@end"))
  end

  def parse_extension(file, line)
    parse_class file, line
  end

  def parse_category(file, line)
    parse_class file, line
  end

  def parse_imp_file

  end
end
