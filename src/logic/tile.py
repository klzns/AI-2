class Tile:
  def __init__(self, kind):
    self.kind = kind
    self.items = []

  def add_item(self, item):
    self.items.append(item)

  def remove_item(self, item):
  	self.items = [i for i in self.items if i != item]

  def has_item(self, item):
    return item in self.items

  def is_deadly(self):
    return self.has_item('B') or self.has_item('E')