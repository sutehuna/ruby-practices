#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

score = ARGV[0]
shots = score.chars.map.with_index do |s, i|
  if s == 'X'
    Shot.new(i, 10)
  else
    Shot.new(i, s.to_i)
  end
end

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

frames.each.with_index do |f, i|
  current_time = f.shot1.time
  f.score = if f.shot1.point == 10 || (f.shot1.point + f.shot2&.point || 0) == 10 # strike or spare
              shots[current_time].point +
                shots[current_time + 1].point +
                shots[current_time + 2].point +
                frames[i - 1]&.score
            else
              f.shot1.point + f.shot2.point + frames[i - 1]&.score
            end
end

puts frames[9].score
