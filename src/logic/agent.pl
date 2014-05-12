/* DYNAMIC */
:- dynamic has_master_sword/0.
:- dynamic safe/2.
:- dynamic visited/2.
:- dynamic on/2.
:- dynamic energy/1.

/* UTILS */
adjacent(X, Y, XX, Y) :- tile_g(XX, Y), XX is X+1.
adjacent(X, Y, XX, Y) :- tile_g(XX, Y), XX is X-1.
adjacent(X, Y, X, YY) :- tile_g(X, YY), YY is Y+1.
adjacent(X, Y, X, YY) :- tile_g(X, YY), YY is Y-1.


/* DETECTORS */
/* Can detect swords on the position we are */
detect_sword(X, Y) :- item_M(X, Y).
detect_sword(X, Y) :- item_F(X, Y).

/* Can detect hearts on the position we are */
detect_heart(X, Y) :- item_C(X, Y).

/* Can detect rupees on the position we are */
detect_rupee(X, Y) :- item_R(X, Y).

/* Can detect holes on adjacent positions */
detect_hole(X, Y) :- adjacent(X, Y, XX, YY), item_B(XX, YY).

/* Can detect enemies on adjacent positions */
detect_enemy(X, Y) :- adjacent(X, Y, XX, YY), item_E(XX, YY).

/* Can detect vortex on adjacent positions */
detect_vortex(X, Y) :- adjacent(X, Y, XX, YY), item_V(XX, YY).

/* INIT */
energy(100).
on(20, 37).
visited(20, 37).
safe(20, 37).

/* BEST ACTIONS, IN ORDER OF PREFERENCE */
/* He's dead, Jim. */
best_action(dead, none1, none2) :- energy(E), E < 1.

/* pick stuff up */
best_action(pick_rupee, X, Y) :- tile_g(X, Y), on(X, Y), detect_rupee(X, Y), retract(item_R(X, Y)).
best_action(pick_sword, X, Y) :- tile_g(X, Y), on(X, Y), detect_sword(X, Y), retract(item_M(X, Y)).
best_action(pick_sword, X, Y) :- tile_g(X, Y), on(X, Y), detect_sword(X, Y), retract(item_F(X, Y)).
best_action(pick_heart, X, Y) :- tile_g(X, Y), on(X, Y), detect_heart(X, Y), energy(E), E < 51, retract(item_C(X, Y)).

/* walk near */
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)), adjacent(X, Y, XX, YY).

/* walk wherever */
best_action(walk, X, Y) :- tile_g(X, Y), safe(X, Y), not(on(X, Y)), not(visited(X, Y)).

/* low on energy and want to attack */
best_action(pick_heart, X, Y) :- tile_g(X, Y), energy(E), E < 31, visited(X, Y), detect_heart(X, Y), retract(item_C(X, Y)).

/* no more open paths, attack! */
best_action(attack, X, Y) :- tile_g(X, Y), tile_g(XX, YY), energy(E), E > 10, visited(XX, YY), detect_enemy(XX, YY), not(safe(X, Y)), adjacent(X, Y, XX, YY), retract(item_E(X, Y)).


/* no more energy to attack, risk going into vortex... */
best_action(walk_into_vortex, X, Y) :- tile_g(X, Y), not(on(X, Y)), tile_g(XX, YY), adjacent(X, Y, XX, YY), visited(XX, YY), detect_vortex(XX, YY).
