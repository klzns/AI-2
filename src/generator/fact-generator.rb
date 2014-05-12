#!/usr/bin/env ruby

require_relative 'map'

# Read map file
map_str = File.read(File.expand_path("../../map.txt", __FILE__))
map = Map.new(map_str)

# Read item file
item_str = File.read(File.expand_path("../../items.txt", __FILE__))

item_str.each_line do |line|
  y, x, item = line.split(' ')
  map.tile(x, y).place(item)
end

lines = [
"/* DYNAMIC */",
":- dynamic item_M/2.",
":- dynamic item_F/2.",
":- dynamic item_C/2.",
":- dynamic item_R/2.",
":- dynamic item_B/2.",
":- dynamic item_E/2.",
":- dynamic item_V/2.",
":- dynamic tile_f/2.",
":- dynamic tile_g/2.",
":- dynamic safe/2."
]

map.each_tile do |tile, x, y|
  lines.push "tile_#{tile.kind}(#{x}, #{y})."
  tile.items.each do |item|
    lines.push "item_#{item}(#{x}, #{y})."
  end
end

puts lines.sort