from tile import Tile

class World:
  def __init__(self, map_str, item_str):
    self.tiles = [map(Tile, line.split(' ')) for line in map_str]

    for item_line in item_str:
      y, x, item = item_line.split(' ')
      self.tiles[int(y)][int(x)].add_item(item.strip())

  def is_danger_detected(self, pos):
    for adjacent in self.adjacents(pos):
      x, y = adjacent
      if not self.tiles[y][x].is_safe():
        return True
    return False

  def path(self, start, direction, end, safe):
    frontier = [{'pos': start, 'history': [], 'dist': self.distance(start, end)}]

    while True:
      state = frontier.pop()

      if state['dist'] == 0:
        # print 'HISTORY from %s to %s' % (start, end), state['history']
        return state['history']

      for adjacent in self.adjacents(state['pos'], safe):
        new_history = list(state['history'])
        new_history.append(adjacent)
        frontier.append({
          'pos': adjacent, 
          'history': new_history, 
          'dist': self.distance(adjacent, end)
        })
      frontier.sort(key=lambda x: -x['dist'])

  def distance(self, start, end):
    return abs(end[0] - start[0]) + abs(end[1] - start[1])

  def neighbors(self, pos, safe = None):
    x, y = pos
    neighs = [(x-1, y-1), (x, y-1), (x+1, y-1),
              (x-1, y  ),           (x+1, y  ),
              (x-1, y+1), (x, y+1), (x+1, y+1)]
    if safe == None:
      return [neigh for neigh in neighs]
    else:
      return [neigh for neigh in neighs if neigh in safe]

  def adjacents(self, pos, safe = None):
    x, y = pos
    neighs = [      (x, y-1),
              (x-1, y), (x+1, y),
                    (x, y+1)]
    if safe == None:
      return [neigh for neigh in neighs]
    else:
      return [neigh for neigh in neighs if neigh in safe]
