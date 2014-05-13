#!/usr/bin/env python

import json
from pyswip.prolog import PrologError

from bridge import Bridge
from agent import Agent
from world import World

# Bridge is the Python-Prolog bridge
bridge = Bridge()

# World is a container for the map and its items
world = World(open('map.txt'), open('items.txt'))

# These are the actions taken by Prolog
action_list = []

# The agent will use the bridge to communicate from and to Prolog.
# It will store taken actions on action_list, and use the world as a support.
agent = Agent(bridge, action_list, world)

# This is the main loop.
while True:

  action = bridge.best_action()
  # print action
  if action:
    agent.execute(action)
  else:
    # print 'STUCK'
    break 

  if action_list[-1] == 'getSword':
    # print 'WIN'
    break
  if action_list[-1] == 'getAttacked':
    # print 'DEAD'
    break


print json.dumps(action_list)
# print 'with cost %d' % agent.cost

# while True:
#   query = raw_input('?- ')
#   print list(bridge.prolog.query(query))
