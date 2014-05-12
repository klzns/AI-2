from tile import Tile
import random

random.seed(7003)

class World:
  def __init__(self, map_str, item_str):
    self.tiles = [map(Tile, line.split(' ')) for line in map_str]

    for item_line in item_str:
      y, x, item = item_line.split(' ')
      self.tiles[int(y)][int(x)].add_item(item.strip())

  def random_position(self):
    while True:
      rpos = (random.randint(0, 41), random.randint(0, 41))
      if self.tile(rpos).kind == 'g':
        return rpos

  def is_danger_detected(self, pos):
    for adjacent in self.adjacents(pos):
      x, y = adjacent
      if not self.tiles[y][x].is_safe():
        return True
    return False

  def astar(self, start, end, safe):
    frontier = [{'pos': start, 'history': [], 'dist': self.distance(start, end)}]

    while True:
      state = frontier.pop()
      
      if state['dist'] == 0:
        # print 'HISTORY from %s to %s' % (start, end), state['history']
        return state['history']

      for adjacent in self.adjacents(state['pos'], safe):
        if len([f for f in frontier if f['pos'] == adjacent]) == 0:
          new_history = list(state['history'])
          new_history.append(adjacent)
          frontier.append({
            'pos': adjacent, 
            'history': new_history, 
            'dist': self.distance(adjacent, end)
          })
      frontier.sort(key=lambda x: -x['dist'])

  def bfs(self, start, end, safe):
    frontier = [{'pos': start, 'history': [], 'dist': self.distance(start, end)}]

    while True:
      state = frontier.pop(0)
      
      if state['dist'] == 0:
        # print 'HISTORY from %s to %s' % (start, end), state['history']
        return state['history']

      for adjacent in self.adjacents(state['pos'], safe):
        if len([f for f in frontier if f['pos'] == adjacent]) == 0:
          new_history = list(state['history'])
          new_history.append(adjacent)
          frontier.append({
            'pos': adjacent, 
            'history': new_history, 
            'dist': self.distance(adjacent, end)
          })


  def path(self, start, end, safe):
    return self.bfs(start, end, safe)

  def distance(self, start, end):
    return abs(end[0] - start[0]) + abs(end[1] - start[1])

  def tile(self, pos):
    x, y = pos
    return self.tiles[y][x]

  def adjacents(self, pos, safe = None):
    x, y = pos
    neighs = [      (x, y-1),
              (x-1, y), (x+1, y),
                    (x, y+1)]
    if safe == None:
      return [neigh for neigh in neighs if self.tile(neigh).kind == 'g']
    else:
      return [neigh for neigh in neighs if self.tile(neigh).kind == 'g' and neigh in safe]
