#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'count'

class WC
  MINIMUM_DIGIT = 7

  class << self
    def run
      files, is_only_lines = parse_argv
      input_statistics = generate_statistics(files)

      if input_statistics.length > 1
        total_statistic = CountStatistic.new(input_statistics)
        max_digits = compute_max_digits(total_statistic)
        puts [*input_statistics, total_statistic].map { |count| count.build_line(max_digits, is_only_lines) }
      else
        max_digits = compute_max_digits(input_statistics.first)
        puts input_statistics.first.build_line(max_digits, is_only_lines)
      end
    end

    private

    def generate_statistics(files)
      if !files.empty?
        files.map { |f| CountStatistic.new(File.read(f), f) }
      else
        [CountStatistic.new($stdin.readlines.join)]
      end
    end

    def compute_max_digits(statistic)
      bytesize_width = [MINIMUM_DIGIT, statistic.bytesize.to_s.length].max
      rows_count_width = [MINIMUM_DIGIT, statistic.rows_count.to_s.length].max
      words_count_width = [MINIMUM_DIGIT, statistic.words_count.to_s.length].max

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
