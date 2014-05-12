#!/usr/bin/env ruby

require_relative 'map'

# Read map file
map_str = File.read(File.expand_path("../../map.txt", __FILE__))
map = Map.new(map_str)

lines = [
":- dynamic tile_f/2.",
":- dynamic tile_g/2."]

map.each_tile do |tile, x, y|
  lines.push "tile_#{tile.kind}(#{x}, #{y})."
end

puts lines.sort