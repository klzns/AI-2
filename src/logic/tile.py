class Tile:
  def __init__(self, kind):
    self.kind = kind
    self.items = []

  def add_item(self, item):
    self.items.append(item)

  def is_safe(self):
    return not self.is_danger()

  def is_danger(self):
    return 'B' in self.items or 'E' in self.items

