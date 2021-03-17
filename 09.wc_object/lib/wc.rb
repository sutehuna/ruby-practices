#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class WC
  @options = {}

  class << self
    attr_accessor :options

    def run
      input_info = format_input
      if input_info.instance_of?(Array)
        total_info = make_total_info(input_info)
        max_b, max_r, max_w = compute_max_digits(total_info)
        str = [*input_info, total_info].map do |info|
          info.to_s(max_b, max_r, max_w)
        end.join("\n")
        puts str
      else
        max_b, max_r, max_w = compute_max_digits(input_info)
        puts input_info.to_s(max_b, max_r, max_w)
      end
    end

    def format_input
      if !ARGV.empty?
        if ARGV.size == 1
          Info.new(File.read(ARGV[0]), ARGV[0])
        else
          ARGV.map { |f| Info.new(File.read(f), f) }
        end
      else
        Info.new($stdin.readlines.join)
      end
    end

    def make_total_info(files)
      total = Info.new
      total.byte_size = files.map(&:byte_size).sum
      total.rows = files.map(&:rows).sum
      total.word_count = files.map(&:word_count).sum
      total.name = 'total'
      total
    end

    def compute_max_digits(total)
      max_b = [7, total.byte_size.to_s.length].max
      max_r = [7, total.rows.to_s.length].max
      max_w = [7, total.word_count.to_s.length].max
      [max_b, max_r, max_w]
    end
  end
end

class Info
  attr_accessor :byte_size, :rows, :word_count, :name

  def initialize(text = '', name = nil)
    text = text.gsub(/\r\n?/, "\n")
    @byte_size = text.bytesize
    @rows = text.scan(/\n/).size
    @word_count = text.split(/[\s　]+/).size
    @name = name
  end

  def to_s(max_b, max_r, max_w)
    if WC.options['l']
      " #{rows.to_s.rjust(max_r)} #{name}"
    else
      " #{rows.to_s.rjust(max_r)} #{word_count.to_s.rjust(max_w)} #{byte_size.to_s.rjust(max_b)} #{name}"
    end
  end
end

WC.run
