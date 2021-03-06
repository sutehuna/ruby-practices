# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'pathname'
require_relative './text_generator'

# Class for performing output
class Command
  def params(argv)
    opt = OptionParser.new
    params = []
    opt.on('-a') { params << :a }
    opt.on('-l') { params << :l }
    opt.on('-r') { params << :r }
    opt.parse!(argv)
    params
  end

  def initialize
    current_dir = Pathname.new(Dir.pwd)
    gen = TextGenerator.new(params(ARGV), current_dir)
    puts gen.generate_text
  end
end

Command.new