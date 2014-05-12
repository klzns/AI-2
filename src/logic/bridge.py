from pyswip import Prolog

class Bridge:
  def __init__(self):
    self.prolog = Prolog()
    self.prolog.consult('facts.pl')
    self.prolog.consult('logic/agent.pl')

  def best_action(self):
    actions = list(self.prolog.query('best_action(Action, Arg1, Arg2)', maxresult=1))
    if len(actions) > 0:
      return actions[0]
    else:
      return None

  def assertz(self, what):
    return list(self.prolog.query("assertz(%s)" % what))

  def retract(self, what):
    return list(self.prolog.query("retract(%s)" % what))

  def retractall(self, what):
    return list(self.prolog.query("retractall(%s)" % what))

  def assert_perceptions(self, perceptions, x, y):
    for p in perceptions.keys():
      self.retract("percept_%s(%d, %d)" % (p, x, y))
      if perceptions[p] == True:
        self.assertz("percept_%s(%d, %d)" % (p, x, y))

  def assert_on(self, x, y):
    self.retractall('on(X, Y)')
    self.retract('visited(%d, %d)' % (x, y))
    self.assertz('on(%d, %d)' % (x, y))
    self.assertz('visited(%d, %d)' % (x, y))
    self.retract('connex(%d, %d)' % (x, y))
    self.assertz('connex(%d, %d)' % (x, y))

  def assert_energy(self, e):
    self.retractall('energy(E)')
    self.assertz('energy(%d)' % e)

  def assert_attacked(self, x, y):
    self.assertz('attacked(%d, %d)' % (x, y))