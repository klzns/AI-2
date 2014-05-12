from tile import Tile
import random

random.seed(7003)

class World:
  def __init__(self, map_str, item_str):
    self.tiles = [map(Tile, line.split(' ')) for line in map_str]

    for item_line in item_str:
      y, x, item = item_line.strip().split(' ')
      self.tile((x, y)).add_item(item)

  def get_perceptions(self, pos):
    tile = self.tile(pos)
    adjacents = self.adjacent_tiles(pos)

    return {
      'rupee' : tile.has_item('R'),
      'heart' : tile.has_item('C'),
      'sword' : tile.has_item('M') or tile.has_item('F'),
      'enemy' : any([tile.has_item('E') for tile in adjacents]),
      'hole'  : any([tile.has_item('B') for tile in adjacents]),
      'vortex': any([tile.has_item('V') for tile in adjacents])
    }

  def path(self, start, end, safe):
    # A-STAR algorithm
    # Goes from start to end.
    # When expanding the frontier, only consider adjacent tiles that are safe. 
    # Safety is defined by Prolog.

    frontier = [{'pos': start, 'history': [], 'dist': self.distance(start, end)}]

    while True:
      frontier.sort(key=lambda x: -x['dist'])
      state = frontier.pop()
      
      if state['dist'] == 0:
        return state['history']

      for adjacent in self.adjacents(state['pos'], safe):
        if adjacent not in state['history'] and len([f for f in frontier if f['pos'] == adjacent]) == 0:
          # INSERT IF:
          #  - not in history (going back and forth is bad!)
          #  - not already in the frontier
          new_history = list(state['history'])
          new_history.append(adjacent)
          frontier.append({
            'pos': adjacent, 
            'history': new_history, 
            'dist': self.distance(adjacent, end)
          })

  def distance(self, start, end):
    xs, ys = start
    xe, ye = end
    # Manhattan distance
    return abs(xe - xs) + abs(ye - ys)

  def tile(self, pos):
    x, y = map(int, pos)
    return self.tiles[y][x]

  def adjacents(self, pos, safe = None):
    x, y = pos
    neighs = [      (x, y-1),
              (x-1, y), (x+1, y),
                    (x, y+1)]

    # Possibly use the safe list as a whitelist
    if safe == None:
      return [neigh for neigh in neighs if self.tile(neigh).kind == 'g']
    else:
      return [neigh for neigh in neighs if self.tile(neigh).kind == 'g' and neigh in safe]

  def adjacent_tiles(self, pos, safe = None):
    return map(self.tile, self.adjacents(pos, safe))


  def random_position(self):
    while True:
      rpos = (random.randint(0, 41), random.randint(0, 41))
      if self.tile(rpos).kind == 'g':
        return rpos