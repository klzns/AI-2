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

  def assert_safe(self, x, y):
    self.retract('safe(%d, %d)' % (x, y))
    self.assertz('safe(%d, %d)' % (x, y))

  def assert_visited(self, x, y):
    self.retract('visited(%d, %d)' % (x, y))
    self.assertz('visited(%d, %d)' % (x, y))

  def assert_on(self, x, y):
    self.retractall('on(X, Y)')
    self.assertz('on(%d, %d)' % (x, y))

  def assert_energy(self, e):
    self.retractall('energy(E)')
    self.assertz('energy(%d)' % e)
