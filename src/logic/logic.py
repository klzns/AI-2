#!/usr/bin/env python

from pyswip import Prolog
import re


class Bridge:
  def __init__(self):
    self.prolog = Prolog()
    self.prolog.consult('facts.pl')
    self.prolog.consult('logic/agent.pl')

  def best_action(self):
    return list(self.prolog.query('best_action(Action, Arg1, Arg2)', maxresult=1))[0]

  def assertz(self, what):
    return self.prolog.assertz(what)

  def retract(self, what):
    return list(self.prolog.query("retract(%s)" % what))

  def retractall(self, what):
    return list(self.prolog.query("retractall(%s)" % what))

  def assert_safe(self, x, y):
    self.assertz('safe(%d, %d)' % (x, y))

  def assert_visited(self, x, y):
    self.assertz('visited(%d, %d)' % (x, y))

  def assert_on(self, x, y):
    self.retractall('on(X, Y)')
    self.assertz('on(%d, %d)' % (x, y))

  def assert_energy(self, e):
    self.retractall('energy(E)')
    self.assertz('energy(%d)' % e)


class Agent:
  def __init__(self, bridge, action_list, eorld):
    self.bridge = bridge
    self.al = action_list
    self.world = world

    self.safe = []
    self.visited = []

    self.energy = 100
    self.points = 0
    self.position = (20, 37)

    # 0 east
    # 1 north
    # 2 west
    # 3 south
    self.direction = 3

    self.update_bridge()

  def add_safe(self, x, y):
    self.bridge.assert_safe(x, y)
    self.safe.append((x, y))

  def add_visited(self, x, y):
    self.bridge.assert_visited(x, y)
    self.visited.append((x, y))

  def update_bridge(self):
    self.bridge.assert_on(*self.position)
    self.bridge.assert_energy(self.energy)
    self.add_visited(*self.position)
    if not self.world.is_danger_detected(self.position):
      for adjacent in self.world.adjacents(self.position):
        self.add_safe(*adjacent)

  def execute(self, action):
    action_name = action['Action']
    arg1 = action['Arg1']
    arg2 = action['Arg2']
    action = getattr(self, action_name)
    action(arg1, arg2)
    self.update_bridge()

  def pick_rupee(self, arg1, arg2):
    self.al.append('getRupee')
    self.points += 10
    self.bridge.retract('item_R(%d, %d)' % self.position)

  def pick_heart(self, arg1, arg2):
    self.al.append('getHeart')
    self.points -= 10
    self.energy += 50
    self.bridge.retract('item_C(%d, %d)' % self.position)

  def pick_sword(self, arg1, arg2):
    self.points -= 100

    if 'M' in self.world.tiles[self.position[1]][self.position[0]].items:
      self.bridge.retract('item_M(%d, %d)' % self.position)
      self.al.append('getSword')
    else:
      self.bridge.retract('item_F(%d, %d)' % self.position)
      self.al.append('getFakeSword')

  def turn_left(self):
    self.al.append('turnLeft')

  def turn_right(self):
    self.al.append('turnRight')

  def move_forward(self):
    self.al.append('moveForward')

  def attack(self, arg1, arg2):
    self.al.append('attack')
    self.energy -= 10

  def face_direction(self, xx, yy):
    x, y = self.position
    assert self.world.distance((x, y), (xx, yy)) == 1, 'New tile not adjacent'

    new_direction = None
    if xx == x+1:
      new_direction = 0
    elif yy == y-1:
      new_direction = 1
    elif xx == x-1:
      new_direction = 2
    elif yy == y+1:
      new_direction = 3

    offset = (new_direction - self.direction) % 4
    if offset == 0:
      # same direction
      pass
    elif offset == 1:
      self.turn_right()
    elif offset == 2:
      self.turn_right()
      self.turn_right()
    else: # if offset == 3:
      self.turn_left()

    self.direction = new_direction

  def walk(self, x, y):
    assert self.position != (x, y), "Must walk to a diferent place. Got %s and %s" % (self.position, (x, y))
    path = self.world.path(self.position, self.direction, (x, y), self.safe)
    for xx, yy in path:
      self.face_direction(xx, yy)
      self.move_forward()
      self.position = (xx, yy)
      self.update_bridge()


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

bridge = Bridge()
world = World(open('map.txt'), open('items.txt'))
action_list = []
agent = Agent(bridge, action_list, world)

while True:
  try:
    action = bridge.best_action()
    print action
    agent.execute(action)
  except IndexError:
    print "NO MORE ACTIONS, ABORTING"
    break 
  if action_list[-1] == 'getSword':
    print 'FIN! GOT THE SWORD :)'
    break
  # print action_list
  # print 'on', list(bridge.prolog.query("on(X, Y)"))
  # print 'visited', list(bridge.prolog.query("visited(X, Y)"))
  # print 'safe', list(bridge.prolog.query("safe(X, Y)"))

print 'Action JSON:'
print action_list