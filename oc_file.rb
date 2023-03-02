# frozen_string_literal: true

class OCFile
  def self.header?(file)
    File.file?(file) && File.basename(file).end_with?('.h')
  end

  def self.implementation?(file)
    File.file?(file) && File.basename(file) =~ /.*\.m(\+\+)?$/
  end

  def self.supported?(file)
    header?
  end

  def initialize(file)
    raise "#{file} is not supported" unless OCFile.supported? file
    @file = file
  end

  def file_name
    File.basename @file
  end

  def handle_line
    temp_file_path = File.join(File.dirname(@file), "#{File.basename}.temp")
    File.open temp_file_path, 'w+' do |new_file|
      File.open @file do |file|
        until file.eof?
          new_line = yield file, file.readline
          new_file.write new_line
        end
      end
    end
    File.delete @file
    File.rename temp_file_path, @file
  end

  def start_parse(options = nil)
    handle_line do |file, line|
      if line.strip.empty? && !options[:trim_empty_line]
        return line
      end

      if Line.protocol? line
        oc_protocol = OCProtocol.new file, line, options
        return oc_protocol.format_line
      elsif Line.class? line
        oc_class = OCClass.new file, line, options
        return oc_class.format_line
      else
        return line
      end
    end
  end
end