# frozen_string_literal: true

# Class that represents statistical data.
class CountStatistic
  attr_reader :bytesize, :rows_count, :words_count, :name

  def initialize(text_or_statistics, name = '')
    if text_or_statistics.is_a?(String)
      text = text_or_statistics
      count_text_statistic(text)
      @name = name
    else
      statistics = text_or_statistics
      calculate_total_statistic(statistics)
      @name = 'total'
    end
  end

  def build_line(max_digits, options)
    line = ''
    line += " #{@rows_count.to_s.rjust(max_digits[:rows_count_width])}" if options.include?(:l) || options.empty?

    if options.empty?
      line += " #{@words_count.to_s.rjust(max_digits[:words_count_width])}" \
                " #{@bytesize.to_s.rjust(max_digits[:bytesize_width])}"
    end

    line + " #{@name}"
  end

  private

  def count_text_statistic(text)
    @bytesize = text.bytesize
    @rows_count = text.scan(/\n/).size
    @words_count = text.strip.split(/\s+/).size
  end

  def init_parameters
    @bytesize = 0
    @rows_count = 0
    @words_count = 0
  end

  def calculate_total_statistic(statistics)
    init_parameters
    statistics.each do |statistic|
      @bytesize += statistic.bytesize
      @rows_count += statistic.rows_count
      @words_count += statistic.words_count
    end
  end
end
