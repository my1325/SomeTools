# frozen_string_literal: true
require 'line'
require 'oc_class'
require 'oc_protocol'
require 'document'
require 'oc_condition'
require 'oc_class_implementation'

class OCFile
  def self.header?(file)
    File.file?(file) && File.basename(file).end_with?('.h')
  end

  def self.implementation?(file)
    File.file?(file) && File.basename(file) =~ /.*\.m(\+\+)?$/
  end

  def self.supported?(file)
    header?(file) || implementation?(file)
  end

  def initialize(file)
    raise "#{file} is not supported" unless OCFile.supported? file

    @file = file
  end

  def file_name
    File.basename @file
  end

  def handle_line
    temp_file_path = File.join(File.dirname(@file), "#{File.basename(@file)}.temp")
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

  def start_parse(options = {})
    handle_line do |file, line|
      line if line.strip.empty? && !options[:trim_empty_line]
      if Line.protocol? line
        oc_protocol = OCProtocol.new file, line, options
        oc_protocol.format_line
      elsif OCClass.class?(line) || OCClass.class_extension?(line) || OCClass.class_category?(line)
        oc_class = OCClass.new file, line, options
        oc_class.format_line
      elsif OCClassImplementation.implementation?(line) || OCClassImplementation.category_implementation?(line)
        oc_class_implementation = OCClassImplementation.new file, line, options
        oc_class_implementation.format_line
      elsif OCCondition.condition? line
        oc_condition = OCCondition.new file, line
        oc_condition.format_line
      elsif Document.document?(line)
        document = Document.new(file, line, @options)
        document.format_line unless options[:trim_document] == false
        '' unless options[:trim_document] == true
      else
        line
      end
    end
  end
end
