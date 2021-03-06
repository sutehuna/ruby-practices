# frozen_string_literal: true

# module for formatting when there is no 'l' option
module ShortFormatter
  TAB_LENGTH = 8

  class << self
    @rows = 0
    @cols = 0
    @length = 0
    @files = []

    def transform(files)
      @files = files
      init_size_information

      # build text by double loop
      (1..@rows).inject('') do |rtext, r|
        rtext + (1..@cols).inject('') { |ctext, c| ctext + create_text(r, c) }
      end
    end

    private

    # Create text for the given row and column.
    def create_text(row, col)
      index = (row - 1) + (col - 1) * @rows

      text = ''
      text += (col == @cols ? @files[index].name : adjust_length(@files[index].name)) if @files[index]
      col == @cols ? "#{text}\n" : text
    end

    # add appropriate tabs
    def adjust_length(name)
      name + "\t" * ((((@length - name.length) - 1) / TAB_LENGTH) + 1)
    end

    # set class instance variables
    def init_size_information
      terminal_cols = `tput cols`.to_i
      max_file_length = @files.max { |a, b| a.name.length <=> b.name.length }.name.length
      @length = max_file_length + TAB_LENGTH - ((max_file_length % TAB_LENGTH))
      @cols, @rows = culculate_extent(terminal_cols, max_file_length)
    end

    def culculate_extent(terminal_cols, max_file_length)
      cols = terminal_cols / @length + ((terminal_cols % @length) > max_file_length ? 1 : 0)
      rows = (@files.size.to_f / cols).ceil
      [cols, rows]
    end
  end
end
