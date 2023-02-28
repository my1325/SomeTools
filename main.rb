#!/usr/bin/ruby
$LOAD_PATH << '.'
require 'oc_file_helper'

file = 'ViewController.h'

helper = OCFileHelper.new file
helper.parse_file
