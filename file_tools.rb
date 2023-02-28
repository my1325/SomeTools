# frozen_string_literal: true

class FileTools
  def initialize(file_path)
    @file_path = file_path
  end

  def handle_file_with_line
    return unless File.exist?(@file_path) && File.file?(@file_path)

    new_file_path = "#{@file_path}_temp"
    File.open new_file_path do |f|
      File.foreach(@file_path) do |line|
        f.write yield line
      end
    end
    File.delete @file_path
    File.rename new_file_path, @file_path
  end

  def replace(string_to_replace, replace_string)
    handle_file_with_line { |line| line.gsub string_to_replace, replace_string }
  end

  def replace_occurs(dict)
    handle_file_with_line do |line|
      dict.each { |k, v| line = line.gsub k, v }
      line
    end
  end

  def replace_file_name(string_to_replace, replace_string)
    return unless File.exist? @file_path

    file_name = File.basename(@file_path).sub string_to_replace, replace_string
    new_path = File.join File.dirname(@file_path), file_name
    File.rename @file_path, new_path
    @file_path = new_path
  end
end
