# frozen_string_literal: true

require_relative './shot'

# Class about one frame
class Frame
  attr_accessor :score
  attr_reader :framenum, :shot1, :shot2, :shot3

  def initialize(framenum, shot1, shot2 = nil, shot3 = nil)
    @framenum = framenum
    @shot1 = shot1
    @shot2 = shot2
    @shot3 = shot3
    @score = 0
  end

  def to_s
    "num:#{@framenum}, #{shot1.point}, #{shot2&.point}, #{shot3&.point}, #{@score}"
  end
end
