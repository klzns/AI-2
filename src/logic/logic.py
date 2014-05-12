#!/usr/bin/env python

from bridge import Bridge
from agent import Agent
from world import World

import json

bridge = Bridge()
world = World(open('map.txt'), open('items.txt'))
action_list = []
agent = Agent(bridge, action_list, world)

while True:
  try:
    action = bridge.best_action()
    print action
    print agent.energy
    agent.execute(action)
  except IndexError:
    print "NO MORE ACTIONS, ABORTING"
    break 
  except BaseException:
    print 'prolog error...'
    while True:
      query = raw_input('?- ')
      print list(bridge.prolog.query(query))
  if action_list[-1] == 'getSword':
    print 'FIN! GOT THE SWORD :)'
    break
  #print action_list
  #print 'on', list(bridge.prolog.query("on(X, Y)"))
  #print 'visited', list(bridge.prolog.query("visited(X, Y)"))
  #print 'safe', list(bridge.prolog.query("safe(X, Y)"))

#print 'Action JSON:'
print json.dumps(action_list)

while True:
  query = raw_input('?- ')
  print list(bridge.prolog.query(query))
