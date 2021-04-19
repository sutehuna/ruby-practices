#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'count'

class WC
  MINIMUM_DIGIT = 7

  class << self
    def run
      files, is_only_lines = parse_argv
      input_counts = generate_counts(files)

      if input_counts.length > 1
        total_count = Count.new(input_counts)
        max_digits = compute_max_digits(total_count)
        puts [*input_counts, total_count].map { |count| count.build_line(max_digits, is_only_lines) }
      else
        max_digits = compute_max_digits(input_counts.first)
        puts input_counts.first.build_line(max_digits, is_only_lines)
      end
    end

    private

    def generate_counts(files)
      if !files.empty?
        files.map { |f| Count.new(File.read(f), f) }
      else
        [Count.new($stdin.readlines.join)]
      end
    end

    def compute_max_digits(total_count)
      bytesize_width = [MINIMUM_DIGIT, total_count.bytesize.to_s.length].max
      rows_count_width = [MINIMUM_DIGIT, total_count.rows_count.to_s.length].max
      words_count_width = [MINIMUM_DIGIT, total_count.words_count.to_s.length].max

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
