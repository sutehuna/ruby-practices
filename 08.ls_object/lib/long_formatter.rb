# frozen_string_literal: true

# module for formatting when there is the 'l' option
module LongFormatter
  # The class that handles the appearance information needed for display
  class VisualStat
    attr_reader :name, :max_width, :side

    def initialize(name, values, side)
      @name = name
      @max_width = values.map { |v| v.to_s.length }.max
      @side = side
    end

    def format(value)
      justs(side, value.to_s)
    end

    private

    def justs(side, value)
      side == 'l' ? value.ljust(max_width, ' ') : value.rjust(max_width, ' ')
    end
  end

  @stats = {}

  class << self
    def transform(files)
      init_stats_from(files)
      files.each { |f| replace_symlink_name!(f) }
      build_text(files)
    end

    private

    def build_text(files)
      text = "total #{files.sum(&:blocks)}\n"
      text + files.map { |f| build_line(f) }.join("\n")
    end

    def build_line(file)
      "#{@stats[:permission].format(file.permission)}  #{@stats[:nlink].format(file.nlink)} " \
      "#{@stats[:uname].format(file.uname)}  #{@stats[:gname].format(file.gname)}  " \
      "#{@stats[:size].format(file.size)} #{@stats[:mtime].format(file.mtime)} #{file.name}"
    end

    def replace_symlink_name!(file)
      return unless file.permission.start_with?('l')

      file.name = "#{file.name} -> #{File.readlink(file.name)}"
    end

    def init_stats_from(files)
      @stats[:permission] = VisualStat.new(:permission, files.map(&:permission), 'l')
      @stats[:nlink] = VisualStat.new(:nlink, files.map(&:nlink), 'r')
      @stats[:uname] = VisualStat.new(:uname, files.map(&:uname), 'l')
      @stats[:gname] = VisualStat.new(:gname, files.map(&:gname), 'l')
      @stats[:size] = VisualStat.new(:size, files.map(&:size), 'r')
      @stats[:mtime] = VisualStat.new(:mtime, files.map(&:mtime), 'r')
    end
  end
end