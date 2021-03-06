# frozen_string_literal: true

# Class about one throw.
class Shot
  attr_reader :time, :point

  def initialize(time, point)
    @time = time
    @point = point
  end

  def to_s
    "#{@time}, #{@point}"
  end
end
