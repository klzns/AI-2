#!/usr/bin/env python

import os
from pyswip import Prolog

class Problem:
  def __init__(self):
    self.prolog = Prolog()
    self.prolog.consult('facts.pl')
    self.prolog.consult('logic/agent.pl')

  def best_action(self):
    return list(self.prolog.query('bestAction(Action, Arg1, Arg2)', maxresult=1))


p = Problem()
a = p.best_action()
print a
