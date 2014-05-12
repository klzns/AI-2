/* DYNAMIC */
/* tiles will be loaded from facts.pl */
:- dynamic tile_f/2.
:- dynamic tile_g/2.

/* these will be asserted by Python */
:- dynamic visited/2.
:- dynamic connex/2.
:- dynamic on/2.
:- dynamic energy/1.
:- dynamic attacked/2.

/* PERCEPTIONS */
/* perceptions will be asserted by Python
   after the Python gives us info about a the dectectors,
   it stays in memory for use later. */
/* these are about the given tiles */
:- dynamic percept_sword/2.
:- dynamic percept_heart/2.
:- dynamic percept_rupee/2.

/* these are about the adjacent tiles of the given tile. */
:- dynamic percept_hole/2.
:- dynamic percept_enemy/2.
:- dynamic percept_vortex/2.


/* UTILS */
adjacent(X, Y, XX, Y) :- tile_g(XX, Y), XX is X+1.
adjacent(X, Y, X, YY) :- tile_g(X, YY), YY is Y-1.
adjacent(X, Y, X, YY) :- tile_g(X, YY), YY is Y+1.
adjacent(X, Y, XX, Y) :- tile_g(XX, Y), XX is X-1.

distance(X, Y, XX, YY, D) :- D is abs(X-XX)+abs(Y-YY).

/* SAFETY */
/* a position is safe if: */
/* - we have visited it before */
safe(X, Y) :- tile_g(X, Y), visited(X, Y).

/* - at least one visited adjacent position has no perception of danger */
safe(X, Y) :- tile_g(X, Y), adjacent(X, Y, XX, YY), visited(XX, YY), 
              not(percept_hole(XX, YY)),
              not(percept_vortex(XX, YY)),
              (not(percept_enemy(XX, YY)); attacked(X, Y)).

/* CONNECTIVITY */
/* in Python, we assert connex to the tile we are on (and accumulate it).
   but in reality, its adjacent tiles are also connex.
   so connex is defined by Python, and connexx by Prolog */
connexx(X, Y) :- tile_g(X, Y), connex(X, Y).
connexx(X, Y) :- tile_g(X, Y), tile_g(XX, YY), connex(XX, YY), adjacent(X, Y, XX, YY).

/* BEST ACTIONS, IN ORDER OF PREFERENCE */
/* dead if we have 0 energy */
best_action(dead, none1, none2) :- energy(E), E < 1.

/* pick stuff up on the current tile */
best_action(pick_rupee, X, Y) :- tile_g(X, Y), on(X, Y), percept_rupee(X, Y).
best_action(pick_sword, X, Y) :- tile_g(X, Y), on(X, Y), percept_sword(X, Y).
best_action(pick_sword, X, Y) :- tile_g(X, Y), on(X, Y), percept_sword(X, Y).
best_action(pick_heart, X, Y) :- tile_g(X, Y), on(X, Y), percept_heart(X, Y), energy(E), E < 51.

/* low on energy and want to attack */
best_action(pick_heart, X, Y) :- tile_g(X, Y), energy(E), E < 31, visited(X, Y), percept_heart(X, Y).

best_action(attack, X, Y) :- tile_g(X, Y), tile_g(XX, YY), energy(E), E > 10, on(XX, YY), percept_enemy(XX, YY), not(safe(X, Y)), adjacent(X, Y, XX, YY).

/* walk near */
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), adjacent(X, Y, XX, YY).
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), distance(X, Y, XX, YY, 2).
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), distance(X, Y, XX, YY, 3).
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), distance(X, Y, XX, YY, 4).
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), distance(X, Y, XX, YY, 5).
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y), on(XX, YY), distance(X, Y, XX, YY, 6).

/* walk wherever */
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), connexx(X, Y).

/* no more open paths, attack! */
best_action(attack, X, Y) :- tile_g(X, Y), tile_g(XX, YY), energy(E), E > 10, visited(XX, YY), percept_enemy(XX, YY), not(safe(X, Y)), adjacent(X, Y, XX, YY).

/* no more energy to attack, risk going into vortex... */
best_action(walk_into_vortex, X, Y) :- tile_g(X, Y), not(on(X, Y)), tile_g(XX, YY), adjacent(X, Y, XX, YY), visited(XX, YY), percept_vortex(XX, YY).

