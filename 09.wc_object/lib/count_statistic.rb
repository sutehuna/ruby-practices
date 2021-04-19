# frozen_string_literal: true

class CountStatistic
  attr_reader :bytesize, :rows_count, :words_count, :name

  def initialize(text_or_counts, name = '')
    if text_or_counts.is_a?(String)
      text = text_or_counts
      @bytesize = text.bytesize
      @rows_count = text.scan(/\n/).size
      @words_count = text.strip.split(/\s+/).size
      @name = name
    else
      counts = text_or_counts
      @bytesize = 0
      @rows_count = 0
      @words_count = 0

      counts.each do |count|
        @bytesize += count.bytesize
        @rows_count += count.rows_count
        @words_count += count.words_count
      end

      @name = 'total'
    end
  end

  def build_line(max_digits, is_only_lines)
    if is_only_lines
      " #{@rows_count.to_s.rjust(max_digits[:rows_count_width])} #{@name}"
    else
      " #{@rows_count.to_s.rjust(max_digits[:rows_count_width])}" \
        " #{@words_count.to_s.rjust(max_digits[:words_count_width])}" \
        " #{@bytesize.to_s.rjust(max_digits[:bytesize_width])} #{@name}"
    end
  end
end
