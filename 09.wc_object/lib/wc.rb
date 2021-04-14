#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'info'

class WC
  MINIMUM_DIGIT = 7

  class << self
    def run
      files, is_only_lines = parse_argv
      input_info = format_input(files)

      if input_info.length > 1
        total_info = build_total_info(input_info)
        max_digits = compute_max_digits(total_info)
        puts [*input_info, total_info].map { |info| info.build_line(max_digits, is_only_lines) }.join("\n")
      else
        max_digits = compute_max_digits(input_info.first)
        puts input_info.first.build_line(max_digits, is_only_lines)
      end
    end

    private

    def format_input(files)
      if !files.empty?
        files.map { |f| Info.new(File.read(f), f) }
      else
        [Info.new($stdin.readlines.join)]
      end
    end

    def build_total_info(files)
      total = Info.new
      total.bytesize = files.map(&:bytesize).sum
      total.rows_count = files.map(&:rows_count).sum
      total.words_count = files.map(&:words_count).sum
      total.name = 'total'

      total
    end

    def compute_max_digits(total_info)
      bytesize_width = [MINIMUM_DIGIT, total_info.bytesize.to_s.length].max
      rows_count_width = [MINIMUM_DIGIT, total_info.rows_count.to_s.length].max
      words_count_width = [MINIMUM_DIGIT, total_info.words_count.to_s.length].max

      { bytesize_width: bytesize_width, rows_count_width: rows_count_width, words_count_width: words_count_width }
    end

    def parse_argv
      is_only_lines = false
      opt = OptionParser.new
      opt.on('-l') { is_only_lines = true }

      [opt.parse!(ARGV), is_only_lines]
    end
  end
end

WC.run
