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
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore, string dtype) T_RadiusDamage;
void(vector org, float damage) SpawnBlood;
void() SuperDamageSound;
void() W_FireFlare;

// Fired Prototypes
void() W_FirePistol;
void() W_FirePistolS;
void() W_FireSMG;
void() W_FirePlasma;
void() W_FireFlame;
void() W_FireNapalm;
void() W_FireClusterGrenade;

void() W_ThrowSticky;

void() W_FireMultiRocket;
void() W_FireProximity;
void() W_ShoveIt;

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");  // new rocket explosion
	precache_sound ("weapons/rocket1i.wav");        // spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav"); // player shotgun
	precache_sound ("weapons/ric1.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");    // ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");  // super spikes
	precache_sound ("weapons/tink1.wav");   // spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav"); // grenade launcher
	precache_sound ("weapons/bounce.wav");          // grenade bounce
	precache_sound ("weapons/shotgn2.wav"); // super shotgun

// FIRED GUNS Precaches
        precache_sound ("fired/arrhit.wav"); // arrow hitting a wall
        precache_sound ("fired/shotgn.wav"); // automatic shotgun 
        precache_sound ("fired/bow.wav");    // bow letting loose an arrow
        precache_sound ("fired/clipin.wav");  // inserting clip for gun
        precache_sound ("fired/flesh.wav");   // flesh hit (arrow
        precache_sound ("fired/heavy.wav");   // heavy bounce 
        precache_sound ("fired/knifed.wav");  // knifed a enemy in back
        precache_sound ("fired/liteup.wav");  // lighting up a flare
        precache_sound ("fired/fball.wav");  // launching a fire ball
        precache_sound ("fired/roast.wav");  // fire roast!
        precache_sound ("fired/pistol.wav");  // firing of pistol
        precache_sound ("fired/plasma.wav");  // firing of pistol
        precache_sound ("fired/rotary.wav");  // firing of rotary gun
        precache_sound ("fired/flare.wav");  // firing of rotary gun
        precache_sound ("fired/unclip.wav");  // removing clip of smg
        precache_sound ("fired/bigload.wav");  // heavy reloading, unused?
        precache_sound ("boss1/throw.wav");  // flamethrower noise

// rotary spin noises.
        precache_sound ("fired/spin10.wav");  
        precache_sound ("fired/spin9.wav");  
        precache_sound ("fired/spin8.wav");  
        precache_sound ("fired/spin7.wav");  
        precache_sound ("fired/spin6.wav");  
        precache_sound ("fired/spin5.wav");  
        precache_sound ("fired/spin4.wav");  
        precache_sound ("fired/spin3.wav");  
        precache_sound ("fired/spin2.wav");  
        precache_sound ("fired/spin1.wav");  

        precache_model ("progs/fired/rotary.mdl"); // rotary cannon
        precache_model ("progs/fired/pistol.mdl"); // pistol
        precache_model ("progs/fired/pistol_s.mdl"); // silenced pistol
        precache_model ("progs/fired/bow.mdl"); // bow
        precache_model ("progs/fired/arrow.mdl"); // the arrow
        precache_model ("progs/fired/firegren.mdl"); // new grenade
        precache_model ("progs/fired/firemiss.mdl"); // new missile

        precache_model ("progs/fired/autoshot.mdl"); // automatic shotgun
        precache_model ("progs/fired/smg.mdl"); // submachine gun
        precache_model ("progs/fired/sticky.mdl"); // sticky bomb (frame 0 for weapon model, frame 1 for projectile)
        precache_model ("progs/fired/knife.mdl"); // knife (both throwing and stabbing)
        precache_model ("progs/fired/knife2.mdl"); // the knife being thrown
        precache_model ("progs/fired/flamer.mdl"); // the flamethrower
        precache_model ("progs/flame.mdl"); // fire torch (for flaming arrows)
        precache_model ("progs/flame2.mdl"); // flame napalm ?
        precache_model ("progs/lavaball.mdl"); // flame napalm 

        precache_model ("progs/fired/fx.spr"); // Additional Sprite effects
        precache_model ("progs/fired/animfx.spr"); // 'animated' fancy sprite effects
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local   vector  source;

	local   vector  org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, 20);
		if (deathmatch > 3)
			T_Damage (trace_ent, self, self, 75);
		else
			T_Damage (trace_ent, self, self, 20);
	}
	else
	{       // hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, 3);
		WriteCoord (MSG_MULTICAST, org_x);
		WriteCoord (MSG_MULTICAST, org_y);
		WriteCoord (MSG_MULTICAST, org_z);
		multicast (org, MULTICAST_PVS);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector    vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local   entity missile;
	local   vector  org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, float damage) SpawnBlood =
{
	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_BLOOD);
	WriteByte (MSG_MULTICAST, 1);
	WriteCoord (MSG_MULTICAST, org_x);
	WriteCoord (MSG_MULTICAST, org_y);
	WriteCoord (MSG_MULTICAST, org_z);
	multicast (org, MULTICAST_PVS);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector    vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, damage);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity  multi_ent;
float   multi_damage;

vector  blood_org;
float   blood_count;

vector  puff_org;
float   puff_count;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
	blood_count = 0;
	puff_count = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

void() Multi_Finish =
{
	if (puff_count)
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, puff_count);
		WriteCoord (MSG_MULTICAST, puff_org_x);
		WriteCoord (MSG_MULTICAST, puff_org_y);
		WriteCoord (MSG_MULTICAST, puff_org_z);
		multicast (puff_org, MULTICAST_PVS);
	}

	if (blood_count)
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_BLOOD);
		WriteByte (MSG_MULTICAST, blood_count);
		WriteCoord (MSG_MULTICAST, blood_org_x);
		WriteCoord (MSG_MULTICAST, blood_org_y);
		WriteCoord (MSG_MULTICAST, blood_org_z);
		multicast (puff_org, MULTICAST_PVS);
	}
};

/*
==============================================================================
BULLETS
==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local   vector  vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		blood_count = blood_count + 1;
		blood_org = org;
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		puff_count = puff_count + 1;
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local   vector direction;
	local   vector  src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();

	traceline (src, src + dir*2048, FALSE, self);
	puff_org = trace_endpos - dir*4;

	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
	Multi_Finish ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;

	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_BIGKICK);
	
	if (deathmatch != 4)
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void() T_MissileTouch =
{
	local float     damg;

//	if (deathmatch == 4)
//	{
//	if ( ((other.weapon == 32) || (other.weapon == 16)))
//		{	
//			if (random() < 0.1)
//			{
//				if (other != world)
//				{
//	//				bprint (PRINT_HIGH, "Got here\n");
//					other.deathtype = "blaze";
//					T_Damage (other, self, self.owner, 1000 );
//					T_RadiusDamage (self, self.owner, 1000, other);
//				}
//			}
//		}	
//	}

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

	damg = 100 + random()*20;
	
	if (other.health)
	{
		other.deathtype = "rocket";
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact


	T_RadiusDamage (self, self.owner, 120, other, "rocket");

//  sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8 * normalize(self.velocity);

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);

	remove(self);
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

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
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.classname = "rocket";

	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================
LIGHTNING
===============================================================================
*/

void(entity from, float damage) LightningHit =
{
	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_LIGHTNINGBLOOD);
	WriteCoord (MSG_MULTICAST, trace_endpos_x);
	WriteCoord (MSG_MULTICAST, trace_endpos_y);
	WriteCoord (MSG_MULTICAST, trace_endpos_z);
	multicast (trace_endpos, MULTICAST_PVS);

	T_Damage (trace_ent, from, from, damage);
};

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity            e1, e2;
	local vector            f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);

	if (trace_ent.takedamage)
	{
		LightningHit (from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		LightningHit (from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		LightningHit (from, damage);
	}
};


void() W_FireLightning =
{
	local   vector          org;
	local   float           cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		if (deathmatch > 3)
		{
			if (random() <= 0.5)
			{
				self.deathtype = "selfwater";
				T_Damage (self, self, self.owner, 4000 );
			}
			else
			{
				cells = self.ammo_cells;
				self.ammo_cells = 0;
				W_SetCurrentAmmo ();
				T_RadiusDamage (self, self, 35*cells, world, "");
				return;
			}
		}
		else
		{
			cells = self.ammo_cells;
			self.ammo_cells = 0;
			W_SetCurrentAmmo ();
			T_RadiusDamage (self, self, 35*cells, world,"");
			return;
		}
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	if (deathmatch != 4)
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_LIGHTNING2);
	WriteEntity (MSG_MULTICAST, self);
	WriteCoord (MSG_MULTICAST, org_x);
	WriteCoord (MSG_MULTICAST, org_y);
	WriteCoord (MSG_MULTICAST, org_z);
	WriteCoord (MSG_MULTICAST, trace_endpos_x);
	WriteCoord (MSG_MULTICAST, trace_endpos_y);
	WriteCoord (MSG_MULTICAST, trace_endpos_z);
	multicast (org, MULTICAST_PHS);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	if (self.voided) {
		return;
	}
	self.voided = 1;

	T_RadiusDamage (self, self.owner, 120, world, "grenade");

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);

	remove (self);
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;         // don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{       
	if (deathmatch != 4)
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
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
	
	newmis.touch = GrenadeTouch;
	
// set newmis duration
	if (deathmatch == 4)
	{
		newmis.nextthink = time + 2.5;		
		self.attack_finished = time + 1.1;
//		self.health = self.health - 1;
		T_Damage (self, self, self.owner, 10 );
	}
	else
		newmis.nextthink = time + 2.5;

	newmis.think = GrenadeExplode;

	setmodel (newmis, "progs/grenade.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector    dir;
	local entity    old;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (deathmatch != 4) 
		self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
};

void(float ox) W_FireSpikes =
{
	local vector    dir;
	local entity    old;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (deathmatch != 4)
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
};



.float hit_z;
void() spike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}
	self.voided = 1;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		other.deathtype = "nail";
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike")
			WriteByte (MSG_MULTICAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_MULTICAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_MULTICAST, TE_SPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);

};

void() superspike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}
	self.voided = 1;


	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		other.deathtype = "supernail";
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_SUPERSPIKE);
		WriteCoord (MSG_MULTICAST, self.origin_x);
		WriteCoord (MSG_MULTICAST, self.origin_y);
		WriteCoord (MSG_MULTICAST, self.origin_z);
		multicast (self.origin, MULTICAST_PHS);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/


// fired - lets you know what gun you have drawn!
void() W_WhatsMyGun =
{
	local string bub;
	if (self.wtype == 0){
		if (self.weapon == IT_AXE) bub = "Axe\n";
		if (self.weapon == IT_SHOTGUN) bub = "Shotgun\n";
		if (self.weapon == IT_SUPER_SHOTGUN) bub = "Super Shotgun\n";
		if (self.weapon == IT_NAILGUN) bub = "Nailgun\n";
		if (self.weapon == IT_SUPER_NAILGUN) bub = "Super Nailgun\n";
		if (self.weapon == IT_GRENADE_LAUNCHER) bub = "Grenade Launcher\n";
		if (self.weapon == IT_ROCKET_LAUNCHER) bub = "Rocket Launcher\n";
		if (self.weapon == IT_LIGHTNING) bub = "Thunderbolt\n";
		}
	else if (self.wtype == 1){
		if (self.weapon == IT_AXE) bub = "Shove\n";
		if (self.weapon == IT_SHOTGUN) bub = "Pistol\n";
		if (self.weapon == IT_SUPER_SHOTGUN) bub = "Auto Shotgun\n";
		if (self.weapon == IT_NAILGUN) bub = "Submachine Gun\n";
		if (self.weapon == IT_SUPER_NAILGUN) bub = "Saw Gun\n";
		if (self.weapon == IT_GRENADE_LAUNCHER) bub = "Proximity Bomb\n";
		if (self.weapon == IT_ROCKET_LAUNCHER) bub = "Multi-Rockets\n";
		if (self.weapon == IT_LIGHTNING) bub = "Plasma Rifle\n";

		}
	else if (self.wtype == 2){
		if (self.weapon == IT_AXE) bub = "Chainsaw\n";
		if (self.weapon == IT_SHOTGUN) bub = "Flare Gun\n";
		if (self.weapon == IT_SUPER_SHOTGUN) bub = "Bow and Arrow\n";
		if (self.weapon == IT_NAILGUN) bub = "?\n";
		if (self.weapon == IT_SUPER_NAILGUN) bub = "Chaingun\n";
		if (self.weapon == IT_GRENADE_LAUNCHER) bub = "Cluster Bomb\n";
		if (self.weapon == IT_ROCKET_LAUNCHER) bub = "Napalm Launcher\n";
		if (self.weapon == IT_LIGHTNING) bub = "Flamethrower\n";

		}
	else if (self.wtype == 3){
		if (self.weapon == IT_AXE) bub = "Knifes\n";
		if (self.weapon == IT_SHOTGUN) bub = "Throwing Knifes\n";
		if (self.weapon == IT_SUPER_SHOTGUN) bub = "Silenced Pistol\n";
		if (self.weapon == IT_NAILGUN) bub = "Pepper Spray\n";
		if (self.weapon == IT_SUPER_NAILGUN) bub = "Gas Gun\n";
		if (self.weapon == IT_GRENADE_LAUNCHER) bub = "Sticky Bomb\n";
		if (self.weapon == IT_ROCKET_LAUNCHER) bub = "Sticky Rockets\n";
		if (self.weapon == IT_LIGHTNING) bub = "Shockwave Cannon\n";

		}
	else if (self.wtype > 3)
		bub = "Something...\n";
	centerprint(self,bub);

};

void() W_SetCurrentAmmo =
{
	player_run ();          // get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
	if (self.wtype == 1) 	self.weaponmodel = "progs/v_axe.mdl";
	else if (self.wtype == 2) 	self.weaponmodel = "progs/v_axe.mdl";
	else if (self.wtype == 3) 	self.weaponmodel = "progs/fired/knife.mdl";
	else	self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
	if (self.wtype == 1) 	self.weaponmodel = "progs/fired/pistol.mdl";
	else if (self.wtype == 2) 	self.weaponmodel = "progs/fired/pistol.mdl";
	else if (self.wtype == 3) 	self.weaponmodel = "progs/fired/knife.mdl";
	else
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
	self.currentammo = self.ammo_shells;
	if (self.wtype == 1) 	self.weaponmodel = "progs/fired/autoshot.mdl";
	else if (self.wtype == 2) 	self.weaponmodel = "progs/fired/bow.mdl";
	else if (self.wtype == 3) 	self.weaponmodel = "progs/fired/pistol_s.mdl";
	else		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		if (self.wtype == 1) 	self.weaponmodel = "progs/fired/smg.mdl";
	else	self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
	if (self.wtype == 2) 	self.weaponmodel = "progs/fired/rotary.mdl";
		else 
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
	if (self.wtype == 3) 	self.weaponmodel = "progs/fired/sticky.mdl";
	else
	self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
	if (self.wtype == 2) 	self.weaponmodel = "progs/fired/flamer.mdl";
		else self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
	local   float   it;
	
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
		return IT_LIGHTNING;
	else if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	else if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	else if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(self.ammo_shells >= 1 && (it & IT_SHOTGUN)  )
		return IT_SHOTGUN;
		
/*
	if(self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) )
		return IT_ROCKET_LAUNCHER;
	else if(self.ammo_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) )
		return IT_GRENADE_LAUNCHER;

*/

	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()  player_axe1;
void()  player_waxe1;
void() player_knife1;
void() player_kni1;

void()  player_axeb1;
void()  player_axec1;
void() player_bow1;
void()  player_axed1;
void()  player_shot1;
void()  player_reload1;
void()  player_autoshot1;
void()  player_shoot1;
void()  player_shootfast1;
void()  player_nmshoot1;
void()  player_nmshootfast1;
void()  player_nail1;
void()  player_light1;
void()  player_rocket1;
void() player_rotary1;

void() W_Attack =
{
	local   float   r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors     (self.v_angle);                 // calculate forward angle for velocity
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE)
	{
		self.attack_finished = time + 0.5;
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		self.attack_finished = time + 0.5;
                W_FireShotgun ();
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		self.attack_finished = time + 0.7;
		W_FireSuperShotgun ();
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		self.attack_finished = time + 0.6;
		W_FireGrenade();
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		self.attack_finished = time + 0.8;
		W_FireRocket();
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		player_light1();
	}
};


void() W_Attack2 =
{
	local   float   r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors     (self.v_angle);                 // calculate forward angle for velocity
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE)
	{
		// Shove
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		player_waxe1 (); 
		self.attack_finished = time + 0.5;
                W_ShoveIt ();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		// PISTOL (Like a billion of games)
		player_shoot1 (); 
		self.attack_finished = time + 0.3;
                W_FirePistol ();
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		// AUTO SHOTGUN (Like Daikatana)
		player_autoshot1 ();
		self.attack_finished = time + 2;
		//W_FireSuperShotgun ();
	}
	else if (self.weapon == IT_NAILGUN)
	{
		// Submachine gun (like a billion of games that want to be halflife)
	if (self.smgclip < FIRED_SMG_CLIP){
		player_shootfast1 (); 
		self.attack_finished = time + 0.05;
		W_FireSMG();
		}
		else
		{
		// reload if out of ammo in the clip.
		player_reload1 (); 
		self.attack_finished = time + 1.5;
		}
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		// TODO: Buzzsaw Gun
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		// TODO: Proximity Mine
		player_rocket1();
		self.attack_finished = time + 0.8;
		W_FireProximity();
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		// TODO: Multi Rockets
		player_rocket1();
		self.attack_finished = time + 1;
		W_FireMultiRocket();
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		// TODO: Plasma Rifle
		player_rocket1();
		self.attack_finished = time + 0.1;
		W_FirePlasma();
	}
};


void() W_Attack3 =
{
	local   float   r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors     (self.v_angle);                 // calculate forward angle for velocity
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE)
	{
		// TODO: Chainsaw. NOT YET
		self.attack_finished = time + 0.5;
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		// TODO: Flare Gun
		player_shot1 ();
		self.attack_finished = time + 0.5;
                W_FireFlare ();
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		// Todo: BOW!
		player_bow1 ();
		self.attack_finished = time + 0.3;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		// TODO:  I don't know yet.
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		// TODO: THE CHAINGUN
		player_rotary1 ();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		// TODO: Cluster Bomb
		player_rocket1();
		self.attack_finished = time + 1.6;
		W_FireClusterGrenade();
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		// TODO: Napalm Launcher
		player_rocket1();
		self.attack_finished = time + 1.2;
		W_FireNapalm();
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		// TODO: Flametheowr
		self.attack_finished = time + 0.05;
		sound (self, CHAN_AUTO, "boss1/throw.wav", 1, ATTN_NORM);
		//player_light1();
		W_FireFlame();
	}
};

void() W_Attack4 =
{
	local   float   r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors     (self.v_angle);                 // calculate forward angle for velocity
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE)
	{
	// 	TODO: Knife!
		self.attack_finished = time + 0.5;
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		player_knife1 ();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
	//    TODO: Throwin Knife!
		player_kni1 ();
		self.attack_finished = time + 0.3;

	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
	// TODO: Silenced Pistol
		player_nmshoot1 ();
		self.attack_finished = time + 0.3;
		W_FirePistolS ();
	}
	else if (self.weapon == IT_NAILGUN)
	{
	// TODO: Pepper Spray MAYBE?
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
	// TODO: Gas Gun
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
	// TODO: The ever so fun STICKY BOMB
		//player_rocket1();
		self.attack_finished = time + 1.3;
		W_ThrowSticky();
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
	// TODO: Sticky ROCKET
		player_rocket1();
		self.attack_finished = time + 0.8;
		W_FireRocket();
	}
	else if (self.weapon == IT_LIGHTNING)
	{
	// TODO: Shockwave CANNON!!!!
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		player_light1();
	}
};
/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local   float   it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}               
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{       // don't have the weapon or the ammo
		sprint (self, PRINT_HIGH, "no weapon.\n");
		return;
	}
	
	if (am)
	{       // don't have the ammo
		sprint (self, PRINT_HIGH, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;               
	W_SetCurrentAmmo ();
	W_WhatsMyGun();
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
//      if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local   float   it, am;
	
	it = self.items;
	self.impulse = 0;
if (self.wtype > 3){
	self.wtype = 0;
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}               
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
	}
 else
   {
	self.wtype = self.wtype + 1;
	W_SetCurrentAmmo ();
	W_WhatsMyGun();
	return;
}
};


/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local   float   it, am;
	
	it = self.items;
	self.impulse = 0;
if (self.wtype < 0){
	self.wtype = 3; 
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}               
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}
}
 else
   {
	self.wtype = self.wtype - 1;
	W_SetCurrentAmmo ();
	W_WhatsMyGun();
	return;
}

};


/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};


/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	ImpulseCommands ();
	
// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
if (DEB_FLAMEFEST)
		{
		W_Attack3 ();
		return;
		}

	if (self.wtype == 1)
		W_Attack2 ();
	else if (self.wtype == 2)
		W_Attack3 ();

	else if (self.wtype == 3)
		W_Attack4 ();

	else
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};


