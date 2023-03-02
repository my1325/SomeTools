#!/usr/bin/ruby
$LOAD_PATH << '.'
# require 'oc_file_helper'
require 'oc_file'
require 'find'

def mix(args)
  dir = args[:dir]
  if dir
    puts "#{dir} is not directory" unless File.directory? dir
    puts "#{dir} is not exists" unless File.exist? dir

    dir_foreach dir do |file|
      if OCFile.supported? file
        oc_file = OCFile.new file
        oc_file.start_parse {}
      end
    end
  elsif args[:file]
    file = args[:file]
    puts "#{file} is not file" unless File.file? file
    puts "#{file} is not exists" unless File.exist? file

    if OCFile.supported? file
      oc_file = OCFile.new file
      oc_file.start_parse
    end
  end
end

def dir_foreach(path)
  if File.directory? path
    Dir.foreach path do |file|
      next if file.start_with?('.')
      dir_foreach(File.join(path, file)) { |f| yield f }
    end
  else
    yield path
  end
end

mix_file = './MixFile'
contents = File.open(mix_file,'r:utf-8',&:read)
if contents.respond_to?(:encoding) && contents.encoding.name != 'UTF-8'
  contents.encode!('UTF-8')
end

eval contents

# puts '//n'.count("/*")