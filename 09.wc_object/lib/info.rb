# frozen_string_literal: true

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
