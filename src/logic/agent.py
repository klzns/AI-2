class Agent:
  def __init__(self, bridge, action_list, world):
    self.bridge = bridge
    self.al = action_list
    self.world = world

    self.energy = 100
    self.cost = 0
    self.position = (20, 37)

    # 0 east, 1 north, 2 west, 3 south
    # think of it as 0pi/2, 1pi/2, 2pi/2, 3pi/2
    self.direction = 3

    self.update_bridge()

  def update_life(self):
    if self.world.tile(self.position).is_deadly():
      self.energy = 0

  def update_bridge(self):
    # Calls assertions on the Prolog bridge for the new position, perceptions, etc
    perceptions = self.world.get_perceptions(self.position)
    self.bridge.assert_perceptions(perceptions, *self.position)
    self.bridge.assert_on(*self.position)
    self.bridge.assert_energy(self.energy)

  def execute(self, action):
    # Call the function with the same name as the action
    action_name = action['Action']
    arg1 = action['Arg1']
    arg2 = action['Arg2']

    action = getattr(self, action_name)
    action(arg1, arg2)

    self.update_life()
    self.update_bridge()

  def get_safe(self):
    return [(s['X'], s['Y']) for s in list(self.bridge.prolog.query("safe(X, Y)"))]

  def get_visited(self):
    return [(s['X'], s['Y']) for s in list(self.bridge.prolog.query("visited(X, Y)"))]

###########
# ACTIONS #
###########
  def pick_rupee(self, x, y):
    self.walk(x, y)

    self.al.append('getRupee')
    self.world.tile(self.position).remove_item('R')
    self.cost += 10

  def pick_heart(self, x, y):
    self.walk(x, y)

    self.al.append('getHeart')
    self.world.tile(self.position).remove_item('C')
    self.cost -= 10
    self.energy = min(self.energy + 50, 100)

  def pick_sword(self, x, y):
    self.walk(x, y)
    self.cost -= 100

    if self.world.tile(self.position).has_item('M'):
      self.al.append('getSword')
    else:
      self.al.append('getFakeSword')

    self.world.tile(self.position).remove_item('M')
    self.world.tile(self.position).remove_item('F')

  def turn_left(self):
    self.cost -= 1
    self.al.append('turnLeft')

  def turn_right(self):
    self.cost -= 1
    self.al.append('turnRight')

  def move_forward(self):
    self.cost -= 1
    self.al.append('moveForward')

  def attack(self, x, y):
    # We wish to attack the tile at x,y
    # First, use ASTAR to walk to a safe tile adjacent to x,y
    safe = self.get_safe()
    adjacents = self.world.adjacents((x, y), safe)
    adjacent = adjacents[0]
    self.walk(*adjacent)

    # Face the monster and attack it!
    self.face_direction(x, y)
    self.cost -= 5
    self.al.append('attack')
    self.energy -= 10
    self.world.tile((x, y)).remove_item('E')

    self.bridge.assert_attacked(x, y)

    self.update_bridge()

  def face_direction(self, xx, yy):
    x, y = self.position

    if xx > x:
      new_direction = 0
    elif yy < y:
      new_direction = 1
    elif xx < x:
      new_direction = 2
    elif yy > y:
      new_direction = 3

    offset = (new_direction - self.direction) % 4
    if offset == 0:
      # same direction
      pass
    elif offset == 1:
      self.turn_left()
    elif offset == 2:
      self.turn_left()
      self.turn_left()
    else: # if offset == 3:
      self.turn_right()

    self.direction = new_direction

  def walk(self, x, y, more_safe = None):
    if self.position == (x, y):
      # Same direction
      return

    safe = self.get_safe()

    if more_safe:
      for m in more_safe:
        safe.append(m)

    path = self.world.path(self.position, (x, y), safe)
    for xx, yy in path:
      self.face_direction(xx, yy)
      self.move_forward()
      self.position = (xx, yy)
      if (xx, yy) != path[-1]:
        self.update_bridge()

  def walk_into_vortex(self, x, y):
    # Walk into the vortex
    self.walk(x, y, (x, y))
    self.update_bridge()

    xr, yr = self.world.random_position()
    self.position = (xr, yr)

    # Sadly, we have to retract all connex in order
    # to make sane decisions about where to walk.
    # This is because we may end up in a disconnex region
    # from where we were.
    self.bridge.retractall('connex(X, Y)')
    
    self.al.append('goIntoVortex')
    self.al.append('teleport:%d,%d' % (xr, yr))

  def dead (self, arg1, arg2):
    self.al.append('getAttacked')
