# frozen_string_literal: true

# The class that holds information about a single file (in a broad sense)
class FileStat
  attr_reader :name, :blocks, :permission, :nlink, :uname, :gname, :size, :mtime

  def initialize(name, stats)
    @name = name
    @blocks = stats.blocks
    @permission = build_permission(name, stats)
    @nlink = stats.nlink
    @uname = Etc.getpwuid(stats.uid).name
    @gname = Etc.getgrgid(stats.gid).name
    @size = stats.size
    @mtime = mtime_to_s(stats.mtime)
  end

  private

  def filetype(name, stats)
    return 'd' if stats.directory?
    return 'l' if FileTest.symlink?(name)
    return 'b' if stats.blockdev?
    return 'c' if stats.chardev?

    '-'
  end

  def build_permission(name, stats)
    filetype(name, stats) + string_permission(stats.mode % 0o1000)
  end

  # 744 => "rwxr--r--"
  def string_permission(permission)
    permission.to_s(8).chars.inject('') { |p, mode| p + mode_to_s(mode.to_i) }
  end

  # 4 => "r--"
  def mode_to_s(mode)
    'xwr'.chars.map.with_index { |c, i| mode[i] == 1 ? c : '-' }.reverse.join
  end

  # Last update time
  # Files that are more than 182 days away from the current show the year
  def mtime_to_s(mtime)
    str = ''
    str += "#{mtime.month.to_s.rjust(2, ' ')} #{mtime.day.to_s.rjust(2, ' ')} "
    str += choose_time_expression(mtime)
    str
  end

  def choose_time_expression(mtime)
    if (Time.now - mtime) >= (60 * 60 * 24 * 182)
      mtime.year.to_s.rjust(5, ' ')
    else
      "#{mtime.hour.to_s.rjust(2, '0')}:#{mtime.min.to_s.rjust(2, '0')}"
    end
  end
end
