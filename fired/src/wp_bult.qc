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

	wp_bult.qc
	If it involves traceline abuse, it goes here!
------------------------------------------------------------------------
*/

// Bullet Weapons
// Yes, melee weapons count as bullet weapons too
float(entity targ) infront;
float(entity targ) knifeinfront;

// Tweaked extended FireBullets for defining damage and range.
void(float shotcount, vector dir, vector spread, float damm, float reange) FireBullets2 =
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
		traceline (src, src + direction*reange, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (damm, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
	Multi_Finish ();
};


// KNIFE
// Weaker than axe... until you hit someone in the back with it 
// then it's your bestest friend ever
void() W_FireKnife =
{
	local   vector  source;
	local   vector  org;

// back stabiin stuff
	local float g;
	local entity moran;
	moran = self;


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
			T_Damage (trace_ent, self, self, 175);
		else
		{
if (trace_ent.health > 0 && trace_ent.solid != SOLID_BSP) {
		self = trace_ent;
		g = knifeinfront(moran);
//		bprint (PRINT_HIGH,ftos(g));
		self = moran;
		sound (self, CHAN_WEAPON, "fired/knifed.wav", 1, ATTN_NORM);

		if (g)
			T_Damage (trace_ent, self, self, 13);
		else if (g == 0){
			T_Damage (trace_ent, self, self, 245); // SUPER GIB KILL IN BACK
        		sound (self, CHAN_AUTO, "fired/pistol.wav", 1, ATTN_NORM); 
		}
		else
			T_Damage (trace_ent, self, self, 13);

		}
	}
	//else
	//	{
		// For hitting doors and buttons that are damagables
	//		T_Damage (trace_ent, self, self, 1);
	//	
	//		sound (self, CHAN_WEAPON, "fired/knifed.wav", 1, ATTN_NORM);
	//	}
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


// Shoving - harmlessly pushing a player
// very good for players, and frikbot v0.09s (BUT TOO BAD WE HAVE 0.10 HERE haha so don't 
// even try it on them.)
void() W_ShoveIt =
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
//		trace_ent.axhitme = 1;
		if (deathmatch > 3)
			trace_ent.velocity = trace_ent.velocity + v_forward*2000; // EXTREME PUSH
		else
			trace_ent.velocity = trace_ent.velocity + v_forward*800; // some push
		sound (self, CHAN_WEAPON, "fired/heavy.wav", 1, ATTN_NORM);
	}
	else
	{       // hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		
	//	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	//	WriteByte (MSG_MULTICAST, TE_GUNSHOT);
	//	WriteByte (MSG_MULTICAST, 3);
	//	WriteCoord (MSG_MULTICAST, org_x);
	//	WriteCoord (MSG_MULTICAST, org_y);
	//	WriteCoord (MSG_MULTICAST, org_z);
	//	multicast (org, MULTICAST_PVS);
	}
};


void() W_FirePistol =
{
	local vector dir;

        sound (self, CHAN_WEAPON, "fired/pistol.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;

	dir = aim (self, 100000);
        FireBullets2 (1, dir, '0.02 0.02 0', 12, 4096);
};


void() W_FirePistolS =
{
	local vector dir;

        sound (self, CHAN_WEAPON, "fired/arrhit.wav", 0.6, ATTN_NORM); 

	//msg_entity = self;
	//WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;

	dir = aim (self, 100000);
        FireBullets2 (1, dir, '0.023 0.023 0', 10, 4096);
};


void() W_FireSMG =
{

	local vector dir;

        sound (self, CHAN_WEAPON, "fired/arrhit.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;

	dir = aim (self, 100000);
        FireBullets2 (1, dir, '0.04 0.04 0', 10, 4096);
	self.smgclip = self.smgclip + 1; // used a bullet
};


void() W_FireRotary =
{
	local vector dir;

        sound (self, CHAN_ITEM, "fired/rotary.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;

	dir = aim (self, 100000);
        FireBullets2 (1, dir, '0.07 0.07 0', 30, 4096);
};



void() W_FireAutoShotgun =
{
	local vector dir;
if (self.ammo_shells < 1){
		player_run(); // STOP FIRING!!!
		return;
	}
        sound (self, CHAN_WEAPON, "fired/shotgn.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;

	dir = aim (self, 100000);
        FireBullets (8, dir, '0.07 0.06 0');
};
