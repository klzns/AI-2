class Tile
  attr_reader :kind, :items

  def limited
    [:B, :E, :V, :M]
  end

  def initialize(kind)
    @kind = kind.to_sym
    @items = []
  end

  def can_place?(item)
    item = item.to_sym

    # Only grass tiles can contain items
    return false if kind == :f

    # If there are no items, then it's okay
    return true if items.empty?

    # Only one item of each kind per terrain
    return false if items.include?(item)

    # If item is limited && we already have one limited
    return false if limited.include?(item) && !(items & limited).empty?

    true
  end

  def place(item)
    item = item.to_sym

    unless can_place?(item)
      raise StandardError.new("Can't place the item #{item} on this tile #{kind} [#{items.join(',')}]")
    end

    items.push(item)

    self
  end

  def to_s
    kind
  end
end
