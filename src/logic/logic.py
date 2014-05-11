#!/usr/bin/env python

from pyswip import Prolog

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

class Agent:
  def __init__(self, bridge, action_list):
    self.bridge = bridge
    self.al = action_list
    self.energy = 100
    self.points = 0
    self.position = (20, 37)
    self.make_safe(20, 37)
    self.make_safe(21, 37)
    self.make_visited(20, 37)
    self.direction = 'down'
    self.update_bridge()

  def update_bridge(self):
    self.bridge.retractall('energy(X)')
    self.bridge.retractall('on(X, Y)')
    self.bridge.assertz('energy(%d)' % self.energy)
    self.bridge.assertz('on(%d, %d)' % self.position)
    self.bridge.assertz('visited(%d, %d)' % self.position)

  def make_safe(self, x, y):
    self.bridge.assertz('safe(%d, %d)' % (x, y))

  def make_visited(self, x, y):
    self.bridge.assertz('visited(%d, %d)' % (x, y))

  def execute(self, action):
    action_name = action['Action']
    arg1 = action['Arg1']
    arg2 = action['Arg2']
    action = getattr(self, action_name)
    action(arg1, arg2)
    self.update_bridge()

  def pick_rupee(self, arg1, arg2):
    self.al.append('pick_rupee')
    self.points += 10
    self.bridge.retract('item_R(%d, %d)' % self.position)

  def pick_heart(self, arg1, arg2):
    self.al.append('pick_heart')
    self.points -= 10
    self.energy += 50

  def pick_sword(self, arg1, arg2):
    self.al.append('pick_sword')
    self.points -= 100

  def attack(self, arg1, arg2):
    self.al.append('attack')
    self.energy -= 10

  def walk(self, x, y):
    pass #todo

bridge = Bridge()
action_list = []
agent = Agent(bridge, action_list)

while True:
  try:
    action = bridge.best_action()
    agent.execute(action)
  except IndexError:
    print "NO MORE ACTIONS, ABORTING"
    break 
  print action_list

