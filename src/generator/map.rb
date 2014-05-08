require_relative 'tile'

class Map
  attr_reader :tiles, :width, :height

  def initialize(map_str)
    @width = map_str.split("\n").first.split(" ").length
    @height = map_str.split("\n").length
    @tiles = map_str.split(/\s*/).map do |kind|
      Tile.new(kind)
    end
  end

  def tile(x, y)
    tiles[x + y*width]
  end

  def each_tile &block
    puts "#{height} #{width}"
    (0...height).each do |y|
      (0...width).each do |x|
        block.call(tile(x, y), x, y)
      end
    end
  end

  def candidates_for(item)
    tiles.select do |tile|
      tile.can_place?(item)
    end
  end

  def place(item)
    candidates = candidates_for(item)

    if candidates.empty?
      raise StandardError.new("No candidate tiles to place this item: #{item}")
    end

    candidates.sample.place(item)
  end
end