/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

/*  
------------------------------------------------------------------------
	Fired Guns
	by Lei-Lei

	wp_bomb.qc
	If it explodes, it goes here!
------------------------------------------------------------------------
*/
void(entity victim, entity killar) SetOffAFire;


// Bomb/Rockets

void() JitterUp;
void() JitterUp =
{
sound (self, CHAN_WEAPON, "fired/liteup.wav", 1, ATTN_NORM);
	self.velocity_x = self.velocity_x + (random() * 400 - 200);
	self.velocity_y = self.velocity_y + (random() * 400 - 200);
	self.velocity_z = self.velocity_z + (random() * 400 - 200);
	self.think = JitterUp;
	self.nextthink = time + 0.1;
};


void() W_LaunchMultiRocket =
{
		if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1000;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_MissileTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 0.1;
	newmis.think = JitterUp;
	newmis.classname = "rocket";

	setmodel (newmis, "progs/fired/firemiss.mdl");
	newmis.skin = 3;
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
};



void() W_FireMultiRocket =
{
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

// I can do it, I can do it 5 times

if (self.ammo_rockets > 4)
	W_LaunchMultiRocket();
if (self.ammo_rockets > 3)
	W_LaunchMultiRocket();
if (self.ammo_rockets > 2)
	W_LaunchMultiRocket();
if (self.ammo_rockets > 1)
	W_LaunchMultiRocket();
if (self.ammo_rockets > 0)
	W_LaunchMultiRocket();

};

// ---------------
// Proximity Mines
// 
// ---------------

void() PonderAboutTargets;

void() PonderAboutTargets =
{
	local entity innocentmictiv;
	//sound (self, CHAN_WEAPON, "fired/heavy.wav", 1, ATTN_NORM);

innocentmictiv = findradius(self.origin, 120);

	
	while (innocentmictiv)
	{
	
			if (innocentmictiv.takedamage)
			{
				// EXPLOLDE!
				T_MissileTouch();
			}
		innocentmictiv = innocentmictiv.chain;
	}

	self.nextthink = time + 0.1;
	self.think = PonderAboutTargets;
	self.health = self.health + 1;
	if (self.skin == 3)	
		self.skin = 2;
	else
		self.skin = 3; // blink like it's dangerous
if (self.health > 100)
	T_MissileTouch(); // explode after a while
};

void() ProxTouch =
{
	if (other == self.owner)
		return;         // don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		// DONT CONTACT EXPLODE!
		return;
	}
	sound (self, CHAN_WEAPON, "fired/heavy.wav", 1, ATTN_NORM);  // bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};



void() W_FireProximity =
{       
if (self.ammo_rockets < 2)
	{
		return; // do nothin!
	}
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 2;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
		
// set newmis speed     

	makevectors (self.v_angle);

	if (self.v_angle_x)
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
	}

	newmis.avelocity = '300 300 300';
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = ProxTouch;
	
// set newmis duration
	if (deathmatch == 4)
	{
		newmis.nextthink = time + 2.5;		
		self.attack_finished = time + 1.1;
//		self.health = self.health - 1;
		//T_Damage (self, self, self.owner, 10 );
	}
	else
		newmis.nextthink = time + 2.5;

	newmis.think = PonderAboutTargets;

	setmodel (newmis, "progs/fired/firegren.mdl");
	newmis.skin = 2;
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};


// SITCKY BOMB
// these suckers stick to people. them blow up seconds after. really fun to use.
// (your opinion may differ)

void() StickyLove;


void() StickyLove =
{

	if (self.budda){
			if (self.budda.health < 1)
				GrenadeExplode(); // boom if low health

		setorigin(self,self.budda.origin);
		self.angles = self.budda.angles;
		self.health = self.health - 1;
		self.think = StickyLove;
		self.nextthink = time + 0.1;
	if (self.health < 1)
		GrenadeExplode(); 
		
		}
	if (!self.budda)
		GrenadeExplode();
};
void() StickyTouch =
{
	
	if (other == self.owner)
		return;         // don't explode on owner

//	if (self.voided) {
//		return;
//	}
//	self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	
	if (other.health)
	{
		other.deathtype = "sticky";
		sound (self, CHAN_WEAPON, "fired/flesh.wav", 1, ATTN_NORM);
		self.budda = other;
		T_Damage (other, self, self.owner, 10 ); // ouch!
		self.think = StickyLove;
		self.nextthink = time + 0.1;
		StickyLove();
		self.avelocity = '0 0 0';
		return;
	}
	sound (self, CHAN_WEAPON, "fired/arrhit.wav", 1, ATTN_NORM);

	self.avelocity = '0 0 0';
	self.movetype = MOVETYPE_FLY;
	self.velocity = '0 0 0'; // stick
	self.think = GrenadeExplode;
	self.nextthink = time + 2;

};

void() W_ThrowSticky =
{       
if (self.ammo_rockets < 2)
	{
		return; // do nothin!
	}
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 2;
	
	sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
	newmis.health = 50;
// set newmis speed     

	makevectors (self.v_angle);

	if (self.v_angle_x)
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
	}

	newmis.avelocity = '300 300 300';
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = StickyTouch;
	
// set newmis duration
	if (deathmatch == 4)
	{
		newmis.nextthink = time + 2.5;		
		self.attack_finished = time + 1.1;
//		self.health = self.health - 1;
		//T_Damage (self, self, self.owner, 10 );
	}
	else
	newmis.nextthink = time + 4;

	newmis.think = GrenadeExplode;

	setmodel (newmis, "progs/fired/sticky.mdl");
	newmis.frame = 1; // go into projectile frame
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};



// Cluster Bomb
// just spews grenades


void() LaunchMunition =
{       
	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "clustgrenade";
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity_x = random() * 500 - 250;
	newmis.velocity_y = random() * 500 - 250;
	newmis.velocity_z = random() * 1000;

	

	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles(newmis.velocity);
	newmis.owner = self.owner; // player still owns all rights from killing
	newmis.touch = GrenadeTouch;
	newmis.nextthink = time + 2;

	newmis.think = GrenadeExplode;

	setmodel (newmis, "progs/fired/firegren.mdl");
	newmis.skin = 1; // dull blue
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};

void() SpewIt =
{
	LaunchMunition();
	LaunchMunition();
	LaunchMunition();
	LaunchMunition();
	LaunchMunition();
	remove(self);
};

void() W_FireClusterGrenade =
{       
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 5;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
		
// set newmis speed     

	makevectors (self.v_angle);

	if (self.v_angle_x)
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
	}

	newmis.avelocity = '100 100 100';

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = ProxTouch;
	
// set newmis duration
	if (deathmatch == 4)
	{
		newmis.nextthink = time + 0.5;		
		self.attack_finished = time + 1.1;
//		self.health = self.health - 1;
		T_Damage (self, self, self.owner, 50 );
	}
	else
		newmis.nextthink = time + 2.5;

	newmis.think = SpewIt;

	setmodel (newmis, "progs/fired/firegren.mdl");
	newmis.skin = 4; // yellow like a bee
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};

// FLAME THROWER
// i'ts in bomb, because it's incendiary. and incendiary is fire.

void() T_FlameTouch =
{
	local float     damg;

	if (other == self.owner)
		return;         // don't explode on owner

	if (self.voided) {
		return;
	}
	self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_SLIME)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (other.health)
	{
		other.deathtype = "flare";
		T_Damage (other, self, self.owner, 4);
	other.burnan = other.burnan + 7;
	if (random() < 0.7)
		SetOffAFire(other,self.owner);		
		remove(self); // fizz off
	}
	// don't do radius damage to the other, because all the damage
	// was done in the impact


	T_RadiusDamage (self, self.owner, 30, other, "flameradius");

//  sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8 * normalize(self.velocity);

	
	remove(self);
};




void() W_FireFlame =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_cells = self.ammo_cells - 0.25;
if (random() < 0.5)	
	sound (self, CHAN_AUTO, "boss1/throw.wav", 0.3, ATTN_NORM);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 340;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_FlameTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 0.7;
	newmis.think = SUB_Remove;
	newmis.classname = "flame";

	setmodel (newmis, "progs/fired/fx.spr");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*10 + '0 0 20' + v_right*14);
	newmis.avelocity_x = random() * 2000 - 1000;
	newmis.avelocity_y = random() * 2000 - 1000;
	newmis.avelocity_z = random() * 2000 - 1000;
	newmis.frame = 3;
};


// Simple Fire torture code
void() FlamingThink;
void() ImBurninHere;



void() FlamingThink =
{

// Used by .firedaemon, so it can track how much flame is set on player, and deal damage
// until it has totally run its course.

	if (self.owner.burnan < 1){
		self.owner.burnan = 0;
	//	self.owner = world;
//		self = world;
		remove(self);
		return;
		}
	if (self.owner.health < 1){
		self.owner.burnan = 0;
	//	self.owner = world;
//		self = world;
		remove(self);
		return;
		}
	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		self.owner.burnan = 0; // no more fire, its put out
	//	self.owner = world;
//		self = world;
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_SLIME)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		self.owner.burnan = 0; // no more fire, its put out
	//	self.owner = world;
//		self = world;
		remove(self);
		return;
	}

	setorigin(self,self.owner.origin); // update flame on owner
	T_Damage (self.owner, self, self.enemy, 5); // ouch!
	self.deathtype = "flame";
	if (random() < 0.5) sound (self, CHAN_WEAPON, "fired/roast.wav", 1, ATTN_NORM); // burn noise 50% chance
	self.nextthink = time + 0.3; // 0.1 too fast?
	self.think = FlamingThink;
	self.owner.burnan = self.owner.burnan - 1; // run some of the internal flames out
	setmodel(self,"progs/flame2.mdl");
	self.frame = 1;			// big fire
	//centerprint(self.owner,"You're on fire\nSeek water!\n");
	//centerprint(self.enemy,"You're burning someone\n\n the code is working!\n");
	ImBurninHere(); // Spawn a visual flame
};


// Fire Napalm Launcher


void() ImBurninHere =
{
// simple function for a flame burst visual effect.
	local entity burny;
	burny = spawn();
	burny.movetype = MOVETYPE_FLY;
	setmodel(burny,"progs/flame2.mdl");
	//burny.frame = 2;
	burny.velocity = '0 0 40';
	burny.think = SUB_Remove;
	burny.nextthink = time + 1;
	setorigin(burny,self.origin);
};

void(entity victim, entity killar) SetOffAFire =
{
	if (!victim.firedaemon)
		victim.firedaemon = spawn(); // spawn if it doesn't exist
		victim.firedaemon.owner = victim;         
		victim.firedaemon.nextthink = time + 0.1;
		victim.firedaemon.think = FlamingThink;  // flame damage torture
		victim.firedaemon.enemy = killar;    // you, burn him!
};

void() T_NapalmTouch =
{
	// Do a fire spread radius here. 
	// When directly contacting a player, 100% chance of fire. 

	if (other == self.owner)
		return;         // can not flame your self!

	if (self.voided) {
		return;
	}
	//self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_SLIME)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (other.health)
	{
		other.deathtype = "napalm";
//		T_Damage (other, self, self.owner, 12);

		// Direct napalm 100% chance set on fire
		other.burnan = other.burnan + 15;
		SetOffAFire(other,self.owner);		
		remove(self); // fizz off
	}

	// not hitting anyone, so do general flame damage surrounding the impact
	sound (self, CHAN_WEAPON, "fired/roast.wav", 1, ATTN_NORM);
	T_FlameDamage (self, self.owner, 80, other, "napalm", 0.8, 7);

	// TODO: make a flame burst effect that is net friendly.
        //sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	ImBurninHere();
	self.nextthink = time + 2; // linger for a little bit then get out!
	self.think = SUB_Remove;

};

void() W_FireNapalm =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "fired/fball.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1200;
	newmis.angles = vectoangles(newmis.velocity) + '90 0 0';
	
	newmis.touch = T_NapalmTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 3;
	newmis.think = SUB_Remove;
	newmis.classname = "napalm";

	setmodel (newmis, "progs/lavaball.mdl");
	//newmis.frame = 1; // big flame!
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
	newmis.avelocity_z = random() * 1000;
	newmis.avelocity_x = random() * 1000;
	newmis.avelocity_y = random() * 1000;
};


void() T_FlareTouch =
{
	// Somewhat of a chance of lighting on fire, but not too much
	// This is a weapon slot 2 weapon after all!

	if (other == self.owner)
		return;         // can not flame your self!

	if (self.voided) {
		return;
	}
	//self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_SLIME)
	{
		sound (self, CHAN_WEAPON, "player/slimbrn2.wav", 1, ATTN_NORM);
		remove(self);
		return;
	}

	if (other.health)
	{
		other.deathtype = "flare";
		T_Damage (other, self, self.owner, 7);
	other.burnan = other.burnan + 4;
	if (random() < 0.7)
		SetOffAFire(other,self.owner);		
		remove(self); // fizz off
	}

	SUB_Remove(); // spark really but i'm lazy

};




void() W_FireFlare =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	
	sound (self, CHAN_WEAPON, "fired/flare.wav", 1, ATTN_NORM);
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1500;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.effects = EF_DIMLIGHT;
	newmis.touch = T_FlareTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 4;
	newmis.think = SUB_Remove;
	newmis.classname = "flare";

	setmodel (newmis, "progs/fired/animfx.spr");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
	newmis.avelocity = '1000 1000 1000';
	
};
