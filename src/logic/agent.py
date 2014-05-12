class Agent:
  def __init__(self, bridge, action_list, world):
    self.bridge = bridge
    self.al = action_list
    self.world = world

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

  def add_visited(self, x, y):
    self.bridge.assert_visited(x, y)

  def update_life(self):
    if self.world.tile(self.position).is_deadly():
      self.energy = 0

  def update_bridge(self):
    self.bridge.assert_on(*self.position)
    self.bridge.assert_safe(*self.position)
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
    self.update_life()
    self.update_bridge()

  def pick_rupee(self, x, y):
    self.walk(x, y)
    self.al.append('getRupee')
    self.points += 10

  def pick_heart(self, x, y):
    self.walk(x, y)
    self.al.append('getHeart')
    self.points -= 10
    self.energy = min(self.energy + 50, 100)

  def pick_sword(self, x, y):
    self.walk(x, y)
    self.points -= 100
    if 'M' in self.world.tiles[self.position[1]][self.position[0]].items:
      self.al.append('getSword')
    else:
      self.al.append('getFakeSword')

  def turn_left(self):
    self.al.append('turnLeft')

  def turn_right(self):
    self.al.append('turnRight')

  def move_forward(self):
    self.al.append('moveForward')

  def attack(self, x, y):
    safe = self.get_safe()
    possible_starting = [pos for pos in safe if pos in self.world.adjacents((x, y), safe)]

    starting = possible_starting[0]
    self.walk(*starting)

    self.face_direction(x, y)
    self.al.append('attack')
    self.energy -= 10
    self.world.tile((x, y)).remove_item('E')

    self.add_safe(x, y)
    self.walk(x, y)

  def get_safe(self):
    return [(s['X'], s['Y']) for s in list(self.bridge.prolog.query("safe(X, Y)"))]

  def get_visited(self):
    return [(s['X'], s['Y']) for s in list(self.bridge.prolog.query("visited(X, Y)"))]

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
      self.turn_left()
    elif offset == 2:
      self.turn_left()
      self.turn_left()
    else: # if offset == 3:
      self.turn_right()

    self.direction = new_direction

  def walk(self, x, y, use_safe = True):
    if self.position == (x, y):
      return
      #raise "Must walk to a diferent place. Got %s and %s" % (self.position, (x, y))

    if use_safe:
      safe = self.get_safe()
    else:
      safe = None

    path = self.world.path(self.position, (x, y), safe)
    for xx, yy in path:
      self.face_direction(xx, yy)
      self.move_forward()
      self.position = (xx, yy)
      self.update_bridge()

  def teleport(self, x, y):
    self.bridge.retractall('safe(X, Y)')
    self.position = (x, y)
    self.al.append('teleport:%d,%d' % (x, y))

  def walk_into_vortex(self, x, y):
    self.walk(x, y, use_safe = False)
    xr, yr = self.world.random_position()
    self.al.append('goIntoVortex')
    self.teleport(xr, yr)

  def dead (self, arg1, arg2):
    self.al.append('getAttacked')
