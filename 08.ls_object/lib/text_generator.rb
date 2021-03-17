# frozen_string_literal: true

require_relative './file_stat'
require_relative './short_formatter'
require_relative './long_formatter'

# class for generating output text
class TextGenerator
  def initialize(options, current_dir)
    @options = options
    @current_dir = current_dir
  end

  def generate_text
    # Create an array of the FileStat class
    files = make_names.map { |f| FileStat.new(f, create_file_stat(f)) }.sort_by(&:name)
    files = files.reverse if @options.include?(:r)
    formatter.transform(files)
  end

  private

  def make_names
    if @options.include?(:a)
      Dir.children(@current_dir) + ['.', '..']
    else
      Dir.children(@current_dir).reject { |f| f[0] == '.' }
    end
  end

  def create_file_stat(filename)
    File.lstat((@current_dir / filename).to_path)
  end

  def formatter
    @options.include?(:l) ? LongFormatter : ShortFormatter
  end
end
