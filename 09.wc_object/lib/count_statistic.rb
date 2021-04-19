# frozen_string_literal: true

# Class that represents statistical data.
class CountStatistic
  attr_reader :bytesize, :rows_count, :words_count, :name

  def initialize(text_or_counts, name = '')
    if text_or_counts.is_a?(String)
      text = text_or_counts
      @bytesize, @rows_count, @word_count = text_statistic
      @name = name
    else
      counts = text_or_counts
      @bytesize, @rows_count, @word_count = [0, 0, 0]

      counts.each do |count|
        @bytesize += count.bytesize
        @rows_count += count.rows_count
        @words_count += count.words_count
      end

      @name = 'total'
    end
  end

  def text_statistic(text){
    [text.bytesize, text.scan(/\n/).size, text.strip.split(/\s+/).size]
  }

  def build_line(max_digits, options)
    line = ''
    line += " #{@rows_count.to_s.rjust(max_digits[:rows_count_width])}" if options.include?(:l) || options.empty?

    if options.empty?
      line += " #{@words_count.to_s.rjust(max_digits[:words_count_width])}" \
                " #{@bytesize.to_s.rjust(max_digits[:bytesize_width])}"
    end

    line + " #{@name}"
  end
end
