// shamelessly copypasted from my vehicle experiment. clean up please.


// bzc 

.float ammo; // generic ammo for all weapons for vehicle and onfooter
.float ammo_max; // maximum ammo a thing can have

.vector thrust;

.entity mount; // vehicle mounted

.entity driver; // vehicle's driver

// Vehicle tag entities
.entity eyeeye; // what the player sees out of when she is in the vehicle
.entity engine1;
.entity engine2;

float SVC_SETVIEWPORT	= 5;
float SVC_SETVIEWANGLES	= 10;

.entity nullhack;

// Guns
.float gun_cycle; // Which gun is selected
.float gun_loaded; // What type of weapon is loaded
.float gun1;
.float gun2;
.float gun3;
.float gun4;
.float gun5;

// Vehicle weapons

float WEP_NULL       		= 0;  //  for filling in
float WEP_MACHINEGUN 		= 1;  // basic bullet shooter
float WEP_ROCKET 		= 2;  // Rocket - generic explosive projectile
float WEP_PLASMA 		= 3;  // Plasma - generic plasma projectile
float WEP_BEAM 			= 4;  // Beam - explosive beam
float WEP_LIGHTNING 		= 5;  // Lightning gun - zaps ammo away
float WEP_TAG 			= 6;  // Tag gun - fire a tag, if hit, volley missiles
float WEP_FLAME 		= 7;  // Flamethrower, toasts organics
float WEP_MORTAR 		= 8;  // Mortar, remote detonation
float WEP_FLARE 		= 9;  // Flare mine, it burns
float WEP_RAVE 			= 10; // Rave gun, explodes alot
float WEP_GUIDED		= 11; // Guided missile, you guide it!
float WEP_SHAKER		= 12; // Shakes up the place
float WEP_GRID 			= 13; // Turns vision into a 'grid'
float WEP_CHARGER 		= 14; // Charges up, releases blast projectiles
//float WEP_RAVE 			= 15;
//float WEP_RAVE 			= 16;
//float WEP_RAVE 			= 17;
//float WEP_RAVE 			= 18;
//float WEP_RAVE 			= 19;

.float thrast;
.float multiboom;

.entity fpweap; // player's first person weapon

.float gunmode; // for player's gun

.float orphan; // for dm = if in the air without a vehicle you own, spawn one when you hit the ground

float	FL_VEHICLE			= 8192;	// for vehicles

.float material;

float MAT_FLESH = 0;
float MAT_METAL = 1;
float MAT_WATER = 2;
.float gravity;
.entity mymortar;