require_relative 'tile'
require_relative 'map'

# Read map file
map_str = File.read(File.expand_path("../../map.txt", __FILE__))

map = Map.new(map_str)

items = ([:B]*10 + [:E]*100 + [:F]*30 + [:V]*10 + [:C]*30 + [:R]*50 + [:M]).shuffle
items.each do |item|
  map.place(item)
end

map.each_tile do |tile, x, y|
  tile.items.each do |i|
    puts "#{x} #{y} #{i}"
  end
end