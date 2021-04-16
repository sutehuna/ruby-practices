# frozen_string_literal: true

class Count
  attr_accessor :bytesize, :rows_count, :words_count, :name

  def initialize(text = '', name = '')
    @bytesize = text.bytesize
    @rows_count = text.scan(/\n/).size
    @words_count = text.strip.split(/\s+/).size
    @name = name
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
