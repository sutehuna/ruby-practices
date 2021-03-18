#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class WC
  class << self
    def run
      files, is_only_lines = parse_argv
      input_info = format_input(files)

      if input_info.instance_of?(Array)
        total_info = build_total_info(input_info)
        max_digits = compute_max_digits(total_info)
        puts [*input_info, total_info].inject('') { |text, info| text += (info.build_line(max_digits, is_only_lines) + "\n") }
      else
        max_digits = compute_max_digits(input_info)
        puts input_info.build_line(max_digits, is_only_lines)
      end
    end

    def format_input(files)
      if !files.nil?
        if files.size == 1
          Info.new(File.read(files.first), files.first)
        else
          files.map { |f| Info.new(File.read(f), f) }
        end
      else
        Info.new($stdin.readlines.join)
      end
    end

    def build_total_info(files)
      total = Info.new
      total.byte_size = files.map(&:byte_size).sum
      total.rows_count = files.map(&:rows_count).sum
      total.words_count = files.map(&:words_count).sum
      total.name = 'total'
      total
    end

    def compute_max_digits(total_info)
      temporary_max_digit = 7
      max_digit_of_byte_size = [temporary_max_digit, total_info.byte_size.to_s.length].max
      max_digit_of_rows_count = [temporary_max_digit, total_info.rows_count.to_s.length].max
      max_digit_of_words_count = [temporary_max_digit, total_info.words_count.to_s.length].max
      { max_digit_of_byte_size: max_digit_of_byte_size, max_digit_of_rows_count: max_digit_of_rows_count, max_digit_of_words_count: max_digit_of_words_count }
    end

    def parse_argv
      is_only_lines = false
      opt = OptionParser.new
      opt.on('-l') { is_only_lines = true }

      [opt.parse!(ARGV), is_only_lines]
    end
  end
end

class Info
  attr_accessor :byte_size, :rows_count, :words_count, :name

  def initialize(text = '', name = '')
    text = text.gsub(/\r\n?/, "\n")
    @byte_size = text.bytesize
    @rows_count = text.scan(/\n/).size
    @words_count = text.split(/[\s　]+/).size
    @name = name
  end

  def build_line(max_digits, is_only_lines)
    if is_only_lines
      " #{@rows_count.to_s.rjust(max_digits[:max_digit_of_rows_count])} #{@name}"
    else
      " #{@rows_count.to_s.rjust(max_digits[:max_digit_of_rows_count])} \
      #{@words_count.to_s.rjust(max_digits[:max_digit_of_words_count])} \
      #{@byte_size.to_s.rjust(max_digits[:max_digit_of_byte_size])} #{@name}"
    end
  end
end

WC.run
