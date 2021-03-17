# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def self.result_for(input_string)
    shots = make_shots(input_string)
    frames = make_frames(shots)
    calculate_score(shots, frames)
  end

  class << self
    private

    def make_shots(input_string)
      input_string.split(',').map.with_index do |s, i|
        if s == 'X'
          Shot.new(i, 10)
        else
          Shot.new(i, s.to_i)
        end
      end
    end

    def make_frames(shots)
      current = 0
      frames = []
      (0..9).each do |i|
        if shots[current].point == 10 # strike
          frames << if i == 9
                      Frame.new(i, shots[current], shots[current + 1], shots[current + 2])
                    else
                      Frame.new(i, shots[current])
                    end
          current += 1
        else
          frames << Frame.new(i, shots[current], shots[current + 1])
          current += 2
        end
      end

      frames
    end

    def calculate_score(shots, frames)
      frames.each.with_index do |f, i|
        current_time = f.shot1.time
        f.score = calculate_frame_score(f, i, shots, frames, current_time)
      end

      frames.last.score
    end

    def calculate_frame_score(frame, index, shots, frames, current_time)
      if frame.shot1.point == 10 || (frame.shot1.point + frame.shot2&.point || 0) == 10 # strike or spare
        shots[current_time].point +
          shots[current_time + 1].point +
          shots[current_time + 2].point +
          frames[index - 1]&.score
      else
        frame.shot1.point + frame.shot2.point + frames[index - 1]&.score
      end
    end
  end
end
