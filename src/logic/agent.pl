/* DYNAMIC */
:- dynamic has_master_sword/0.
:- dynamic safe/2.
:- dynamic visited/2.
:- dynamic on/2.
:- dynamic energy/1.

/* UTILS */
adjacent(X, Y, XX, Y) :- XX is X+1, tile_g(XX, Y).
adjacent(X, Y, XX, Y) :- XX is X-1, tile_g(XX, Y).
adjacent(X, Y, X, YY) :- YY is Y+1, tile_g(X, YY).
adjacent(X, Y, X, YY) :- YY is Y-1, tile_g(X, YY).

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
best_action(pick_rupee, none1, none2) :- on(X, Y), detect_rupee(X, Y), retract(item_R(X, Y)).
best_action(pick_sword, none1, none2) :- on(X, Y), detect_sword(X, Y), retract(item_M(X, Y)), retract(item_F(X, Y)).
best_action(pick_heart, none1, none2) :- on(X, Y), detect_heart(X, Y), energy(E), E < 100, retract(item_C(X, Y)).

best_action(walk, X, Y) :- safe(X, Y), not(on(X, Y)), not(visited(X, Y)), tile_g(X, Y), adjacent(X, Y, XX, YY).
best_action(walk, X, Y) :- safe(X, Y), not(on(X, Y)), not(visited(X, Y)), tile_g(X, Y).

best_attack(attack, X, Y) :- adjacent(X, Y, XX, YY), visited(XX, YY), detect_enemy(XX, YY), not(safe(X, Y)).

