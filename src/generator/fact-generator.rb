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


map.each_tile do |tile, x, y|
  puts "terrain(#{x}, #{y}, #{tile.kind})."
  tile.items.each do |item|
    puts "item(#{x}, #{y}, #{item})."
  end
end
