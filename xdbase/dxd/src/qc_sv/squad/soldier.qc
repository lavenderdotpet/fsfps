void() soldier_think;

float(float animation) animation_start =
{
	if (animation == 0)
		return animation_start_0;
	if (animation == 1)
		return animation_start_1;
	if (animation == 2)
		return animation_start_2;
	if (animation == 3)
		return animation_start_3;
	if (animation == 4)
		return animation_start_4;
	if (animation == 5)
		return animation_start_5;
	if (animation == 6)
		return animation_start_6;
	if (animation == 7)
		return animation_start_7;
	if (animation == 8)
		return animation_start_8;
	if (animation == 9)
		return animation_start_9;
	if (animation == 10)
		return animation_start_10;
	if (animation == 11)
		return animation_start_11;
	if (animation == 12)
		return animation_start_12;
	if (animation == 13)
		return animation_start_13;
	if (animation == 14)
		return animation_start_14;
	if (animation == 15)
		return animation_start_15;
	if (animation == 16)
		return animation_start_16;
	if (animation == 17)
		return animation_start_17;
	if (animation == 18)
		return animation_start_18;
	if (animation == 19)
		return animation_start_19;
	if (animation == 20)
		return animation_start_20;
	if (animation == 21)
		return animation_start_21;
};

float(float animation) animation_frames =
{
	if (animation == 0)
		return animation_frames_0;
	if (animation == 1)
		return animation_frames_1;
	if (animation == 2)
		return animation_frames_2;
	if (animation == 3)
		return animation_frames_3;
	if (animation == 4)
		return animation_frames_4;
	if (animation == 5)
		return animation_frames_5;
	if (animation == 6)
		return animation_frames_6;
	if (animation == 7)
		return animation_frames_7;
	if (animation == 8)
		return animation_frames_8;
	if (animation == 9)
		return animation_frames_9;
	if (animation == 10)
		return animation_frames_10;
	if (animation == 11)
		return animation_frames_11;
	if (animation == 12)
		return animation_frames_12;
	if (animation == 13)
		return animation_frames_13;
	if (animation == 14)
		return animation_frames_14;
	if (animation == 15)
		return animation_frames_15;
	if (animation == 16)
		return animation_frames_16;
	if (animation == 17)
		return animation_frames_17;
	if (animation == 18)
		return animation_frames_18;
	if (animation == 19)
		return animation_frames_19;
	if (animation == 20)
		return animation_frames_20;
	if (animation == 21)
		return animation_frames_21;
};

void() animation_setup =
{
	local float i;

	anim_setup = TRUE;

	animation_frames_0 = 10;	// Crouch death
	animation_frames_1 = 11;	// Stand death thrown backwards
	animation_frames_2 = 12;	// Stand death turn over;
	animation_frames_3 = 9;		// Stand death drop flat
	animation_frames_4 = 5;		// Crouch pain
	animation_frames_5 = 5;		// Stand pain 1
	animation_frames_6 = 7;		// Stand pain 2
	animation_frames_7 = 5;		// Stand pain 3
	animation_frames_8 = 10;	// Melee
	animation_frames_9 = 14;	// Reload
	animation_frames_10 = 16;	// Grenade
	animation_frames_11 = 7;	// Draw hip
	animation_frames_12 = 8;	// Fire hip
	animation_frames_13 = 9;	// Draw aim
	animation_frames_14 = 2;	// Fire aim
	animation_frames_15 = 9;	// Draw crouch
	animation_frames_16 = 13;	// Fire crouch
	animation_frames_17 = 7;	// Left strafe fire
	animation_frames_18 = 7;	// Right strafe fire
	animation_frames_19 = 9;	// Run
	animation_frames_20 = 32;	// Walk
	animation_frames_21 = 22;	// Stand

	animation_start_0 = 0;
	animation_start_1 = animation_start_0 + animation_frames_0;
	animation_start_2 = animation_start_1 + animation_frames_1;
	animation_start_3 = animation_start_2 + animation_frames_2;
	animation_start_4 = animation_start_3 + animation_frames_3;
	animation_start_5 = animation_start_4 + animation_frames_4;
	animation_start_6 = animation_start_5 + animation_frames_5;
	animation_start_7 = animation_start_6 + animation_frames_6;
	animation_start_8 = animation_start_7 + animation_frames_7;
	animation_start_9 = animation_start_8 + animation_frames_8;
	animation_start_10 = animation_start_9 + animation_frames_9;
	animation_start_11 = animation_start_10 + animation_frames_10;
	animation_start_12 = animation_start_11 + animation_frames_11;
	animation_start_13 = animation_start_12 + animation_frames_12;
	animation_start_14 = animation_start_13 + animation_frames_13;
	animation_start_15 = animation_start_14 + animation_frames_14;
	animation_start_16 = animation_start_15 + animation_frames_15;
	animation_start_17 = animation_start_16 + animation_frames_16;
	animation_start_18 = animation_start_17 + animation_frames_17;
	animation_start_19 = animation_start_18 + animation_frames_18;
	animation_start_20 = animation_start_19 + animation_frames_19;
	animation_start_21 = animation_start_20 + animation_frames_20;
};

void(float animation) animate_loop =
{
	if (animation != self.lastanim)
		self.animframe = 0;
	
	self.lastanim = animation;

	self.frame = animation_start(animation) + self.animframe;
	self.animframe = self.animframe + 1;

	if (self.animframe >= animation_frames(animation))
		self.animframe = 0;
};

float(float animation) animate_single =
{
	local float anim_frame;

	if (animation != self.lastanim)
		self.animframe = 0;
	
	self.lastanim = animation;

	self.frame = animation_start(animation) + self.animframe;
	self.animframe = self.animframe + 1;

	if (self.animframe >= animation_frames(animation))
	{
		self.animframe = 0;
		return TRUE;
	}

	return FALSE;
};

void(entity ent, float chan, string sond, float vol, float atn) speak =
{
	local entity guy;

	sound(ent, chan, sond, vol, ATTN_STATIC);
	
	guy = findradius(ent.origin, 500);
	
	while(guy)
	{
		if (guy.classname == "monster_trooper")
			guy.enemy = ent.enemy;
		
		guy = guy.chain;
	}
};

entity() FindEnemy =
{
	local entity	client;
	local float		r, flo;

	client = checkclient ();
	if (!client)
		return world;	// current check entity isn't in PVS

	if (client == self.enemy)
		return self.enemy;

	if (client.flags & FL_NOTARGET)
		return world;

	r = range (client);
	if (r == RANGE_FAR)
		if (random() > 0.1)
			return world;
	
	if (!visible (client))
		return world;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return world;
	}
	else if (r == RANGE_MID)
	{
		if (!infront (client))
			return world;
	}

	if (voice_time < time)
	{
		flo = floor(random() * 3) + 1;

		if (flo == 1)
			speak (self, CHAN_VOICE, "voices/gethim.wav", 1, ATTN_IDLE);
		if (flo == 2)
			speak (self, CHAN_VOICE, "voices/thereheis.wav", 1, ATTN_IDLE);
		if (flo == 1)
			speak (self, CHAN_VOICE, "voices/openfire.wav", 1, ATTN_IDLE);

		voice_time = time + 5 + (3 * random());
	}

	return client;
};

float(entity ent, entity ent2) visiblefrom =
{
	local vector	spot1, spot2;
	
	spot1 = ent.origin;
	spot2 = ent2.origin;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

float(entity sel, entity targ) infrontof =
{
	local vector	vec;
	local float		dot;
	
	makevectors (sel.angles);
	vec = normalize (targ.origin - sel.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};

entity() findcover =
{
	local entity ent;
	local float i, j;

	ent = nearestway(self);

	foundcover = TRUE;

	if ((vlen(ent.origin - self.origin) > 100) && !visiblefrom(ent, self.enemy))
		return ent;
	else
	{
		if (ent.link1)
		{
			if ((!visiblefrom(ent.link1, self.enemy)) || (!infrontof(self.enemy, ent.link1)))
			{
				if (!ent.link1.waycost)
					i = i + 1;
			}
		}
		if (ent.link2)
		{
			if ((!visiblefrom(ent.link2, self.enemy)) || (!infrontof(self.enemy, ent.link2)))
			{
				if (!ent.link2.waycost)
					i = i + 1;
			}
		}
		if (ent.link3)
		{
			if ((!visiblefrom(ent.link3, self.enemy)) || (!infrontof(self.enemy, ent.link3)))
			{
				if (!ent.link3.waycost)
					i = i + 1;
			}
		}
		if (ent.link4)
		{
			if ((!visiblefrom(ent.link4, self.enemy)) || (!infrontof(self.enemy, ent.link4)))
			{
				if (!ent.link4.waycost)
					i = i + 1;
			}
		}
		if (ent.link5)
		{
			if ((!visiblefrom(ent.link5, self.enemy)) || (!infrontof(self.enemy, ent.link5)))
			{
				if (!ent.link5.waycost)
					i = i + 1;
			}
		}
		if (ent.link6)
		{
			if ((!visiblefrom(ent.link6, self.enemy)) || (!infrontof(self.enemy, ent.link6)))
			{
				if (!ent.link6.waycost)
					i = i + 1;
			}
		}
		
		if (i == 0)
		{
			foundcover = FALSE;
			return ent.link1;
		}

		i = floor(random() * i) + 1;

		if (ent.link1)
		{
			if ((!visiblefrom(ent.link1, self.enemy)) || (!infrontof(self.enemy, ent.link1)))
			{
				if (!ent.link1.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link1;
				}
			}
		}
		if (ent.link2)
		{
			if ((!visiblefrom(ent.link2, self.enemy)) || (!infrontof(self.enemy, ent.link2)))
			{
				if (!ent.link2.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link2;
				}
			}
		}
		if (ent.link3)
		{
			if ((!visiblefrom(ent.link3, self.enemy)) || (!infrontof(self.enemy, ent.link3)))
			{
				if (!ent.link3.waycost)
				{
					j = j + 1;
					if (i == j)
					return ent.link3;
				}
			}
		}
		if (ent.link4)
		{
			if ((!visiblefrom(ent.link4, self.enemy)) || (!infrontof(self.enemy, ent.link4)))
			{
				if (!ent.link4.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link4;
				}
			}
		}
		if (ent.link5)
		{
			if ((!visiblefrom(ent.link5, self.enemy)) || (!infrontof(self.enemy, ent.link5)))
			{
				if (!ent.link5.waycost)
				{
					j = j + 1;
					if (i == j)
					return ent.link5;
				}
			}
		}
		if (ent.link6)
		{
			if ((!visiblefrom(ent.link6, self.enemy)) || (!infrontof(self.enemy, ent.link6)))
			{
				if (!ent.link6.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link6;
				}
			}
		}
	}

	foundcover = FALSE;

	return ent.link1;
};

entity() findgoodshot =
{
	local entity ent;
	local float i, j;

	ent = nearestway(self);

	if ((vlen(ent.origin - self.origin) > 100) && visiblefrom(ent, self.enemy))
		return ent;
	else
	{
		if (ent.link1)
		{
			if (visiblefrom(ent.link1, self.enemy))
			{
				if (!ent.link1.waycost)
					i = i + 1;
			}
		}
		if (ent.link2)
		{
			if (visiblefrom(ent.link2, self.enemy))
			{
				if (!ent.link2.waycost)
					i = i + 1;
			}
		}
		if (ent.link3)
		{
			if (visiblefrom(ent.link3, self.enemy))
			{
				if (!ent.link3.waycost)
					i = i + 1;
			}
		}
		if (ent.link4)
		{
			if (visiblefrom(ent.link4, self.enemy))
			{
				if (!ent.link4.waycost)
					i = i + 1;
			}
		}
		if (ent.link5)
		{
			if (visiblefrom(ent.link5, self.enemy))
			{
				if (!ent.link5.waycost)
					i = i + 1;
			}
		}
		if (ent.link6)
		{
			if (visiblefrom(ent.link6, self.enemy))
			{
				if (!ent.link6.waycost)
					i = i + 1;
			}
		}
		
		if (i == 0)
			return ent.link1;

		i = floor(random() * i) + 1;

		if (ent.link1)
		{
			if (visiblefrom(ent.link1, self.enemy))
			{
				if (!ent.link1.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link1;
				}
			}
		}
		if (ent.link2)
		{
			if (visiblefrom(ent.link2, self.enemy))
			{
				if (!ent.link2.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link2;
				}
			}
		}
		if (ent.link3)
		{
			if (visiblefrom(ent.link3, self.enemy))
			{
				if (!ent.link3.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link3;
				}
			}
		}
		if (ent.link4)
		{
			if (visiblefrom(ent.link4, self.enemy))
			{
				if (!ent.link4.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link4;
				}
			}
		}
		if (ent.link5)
		{
			if (visiblefrom(ent.link5, self.enemy))
			{
				if (!ent.link5.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link5;
				}
			}
		}
		if (ent.link6)
		{
			if (visiblefrom(ent.link6, self.enemy))
			{
				if (!ent.link6.waycost)
				{
					j = j + 1;
					if (i == j)
						return ent.link6;
				}
			}
		}
	}

	return ent.link1;
};

void() spawnflash =
{
	local entity ent;
	ent = spawn();
	makevectors(self.angles);
	setorigin(ent, self.origin + v_forward * 50);
	ent.effects = EF_MUZZLEFLASH;
	ent.think = SUB_Remove;
	ent.nextthink = time + 2;
};

void() fire_mgun =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "weapons/mgun.wav", 1, ATTN_IDLE);	

	en = self.enemy;
	
	dir = en.origin - en.velocity*0.1;
	dir = normalize (dir - self.origin);
	
	FireBullets (1, dir, '0.1 0.1 0');
	spawnflash();
};

void() GrenTouch =
{
	local entity ent;
	
	if (other == self.owner)
		return;		// don't explode on owner

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound

	danger(self.origin, 140, 1000, 4);

	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
	}
};

void() throw_grenade =
{
        local vector vec, vposa, vposb, hposa, hposb;
        local float len, vert, horiz, accel, hdist, vdist, dist, gh;
        local entity missile, ent, cg;

	vec = vectoangles(self.enemy.origin - self.origin);

	makevectors (vec);

        vposa = self.enemy.origin;
        vposa_x = 0;
        vposa_y = 0;
        vposb = self.origin + '0 0 1';
        vposb_x = 0;
        vposb_y = 0;
        hposa = self.enemy.origin;
        hposa_z = 0;
        hposb = self.origin;
        hposb_z = 0;

        hdist = vlen(hposa - hposb);
	if (hdist > 600)
		hdist = 600;
        vdist = vlen(vposa - vposb);

        horiz = 400;
        vert = hdist + vdist;
        vert = vert * 800;
        vert = vert / 2;
        vert = vert / horiz;

	missile = spawn ();
	missile.owner = self;
        missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
        missile.classname = "grenade";
        vec = normalize(hposa - hposb);
	vec_x = vec_x + vec_x * (crandom() * 0.3);
	vec_y = vec_y + vec_y * (crandom() * 0.3);
	missile.velocity = vec * horiz;
        missile.velocity_z = vert;
	missile.angles = vectoangles(missile.velocity);
	missile.effects = EF_NOMODELFLAGS;
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenTouch;
	
// set missile duration
	missile.nextthink = time + 4;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_mgun =
{

	sound (self, CHAN_WEAPON, "weapons/mgun.wav", 1, ATTN_IDLE);	

	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	makevectors(self.v_angle);
	FireBullets (1, v_forward, '0.02 0.02 0');
	spawnflash();
};

float() strafe_direction = 
{
	float ldist, rdist;
	vector oldorg;
	
	if (self.strafing)
		return self.strafing;

	makevectors(self.angles);
	oldorg = self.origin;

	walkmove(self.angles_y - 90, 100);
	ldist = vlen(self.origin - oldorg);
	setorigin(self, oldorg);

	walkmove(self.angles_y + 90, 100);
	rdist = vlen(self.origin - oldorg);

	setorigin(self, oldorg);

	if (ldist > rdist)
		return 1;
	
	return 2;
};

void() combat_ai =
{
	local entity oldself, ent;
	local float flo;

	if (self.objective == world)
	{
		if (self.grenade_throw)
		{
			if (voice_time < time)
			{
				if (random() < 0.66)
					speak (self, CHAN_VOICE, "voices/firehole.wav", 1, ATTN_IDLE);	
				else
					speak (self, CHAN_VOICE, "voices/takecover.wav", 1, ATTN_IDLE);	
					
				voice_time = time + 5 + (random() * 3);
			}
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
			ChangeYaw();
			if (animate_single(ANIM_GRENADE))
			{
				self.grenade_throw = FALSE;
			}

			if (self.animframe == 10)
				throw_grenade();
		}
		else if (self.ammo_nails == 0)
		{
			if (((!visible(self.enemy)) || (!infront(self.enemy))) && (!self.reloading))
			{
				self.reloading = TRUE;
			}
			if (self.reloading)
			{
				if (animate_single(ANIM_RELOAD))
				{
//					bprint ("Reloaded\n");
					self.reloading = FALSE;
					self.ammo_nails = 30;
				}
			}
			else
			{
				if (voice_time < time)
				{
					flo = random();
					if (flo < 0.33)
						speak (self, CHAN_VOICE, "voices/ammo.wav", 1, ATTN_IDLE);	
					else if (flo < 0.66)
						speak (self, CHAN_VOICE, "voices/reload.wav", 1, ATTN_IDLE);	
					else
						speak (self, CHAN_VOICE, "voices/runninglow.wav", 1, ATTN_IDLE);
					
					voice_time = time + 5 + (random() * 3);
				}
				self.objective = findcover();
				
				if (!foundcover)
				{
					self.objective = world;
					self.reloading = TRUE;
				}
			}
		}
		else if ((self.fire_time > time) && (visible(self.enemy)))
		{
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
			ChangeYaw();

			traceline(self.origin, self.enemy.origin, 2, world);

			if (self.weapon_drawn)
			{
				if ((trace_ent != self.enemy) && (trace_ent != world))
					self.fire_time = 0;
				else
				{
					if (self.fire_type == 3)
						animate_loop(ANIM_CROUCHFIRE);
					else
					{
						makevectors(self.enemy.v_angle);
						traceline(self.enemy.origin, self.enemy.origin + (v_forward * 10000), FALSE, self.enemy);

						if (random() < 0.05)
							self.strafing = strafe_direction();

						if ((trace_ent == self) && (random() < 0.25))
							self.strafing = strafe_direction();
						if (!self.strafing)
						{
							if (self.fire_type == 1)
								animate_loop(ANIM_HIPFIRE);
							else if (self.fire_type == 2)
								animate_loop(ANIM_AIMFIRE);
						}
					}

					if (self.strafing == 1)
					{
						self.angles_y = vectoyaw(self.enemy.origin - self.origin);
						if (!walkmove(self.angles_y - 90, 5))
							self.strafing = 2;
						animate_loop(ANIM_LEFTFIRE);
					}
					else if (self.strafing == 2)
					{
						self.angles_y = vectoyaw(self.enemy.origin - self.origin);
						if (!walkmove(self.angles_y + 90, 5))
							self.strafing = 1;
						animate_loop(ANIM_RIGHTFIRE);
					}

					self.ammo_nails = self.ammo_nails - 1;
					fire_mgun();
				}
			}
			else
			{
				if ((trace_ent != self.enemy) && (trace_ent != world))
				{			
					if (trace_ent.health)
					{
						oldself = self;
						self = trace_ent;
				
						if (!self.objective)
						{
							self.objective = findgoodshot();
							self.fire_time = 0;
						}
							
						self = oldself;
					}
				}
				
				if (!self.fire_type)
					self.fire_type = floor(random() * 3) + 1;

				if (self.fire_type == 1)
					if (animate_single(ANIM_HIPDRAW))
						self.weapon_drawn = TRUE;
				if (self.fire_type == 2)
					if (animate_single(ANIM_AIMDRAW))
						self.weapon_drawn = TRUE;
				if (self.fire_type == 3)
					if (animate_single(ANIM_CROUCHDRAW))
						self.weapon_drawn = TRUE;
			}
		}	
		else if (!visible(self.enemy))
		{
			if ((grenade_time < time) && (random() < 0.5))
			{
				if ((vlen(self.enemy.origin - self.origin) < 500) && (vlen(self.enemy.origin - self.origin) > 200))
				{
					traceline(self.origin, self.origin + '0 0 128', TRUE, self);
					traceline(trace_endpos, self.enemy.origin, FALSE, world);

					if (vlen(trace_endpos - self.enemy.origin) < 100)
					{
						grenade_time = time + 10;
						self.grenade_throw = TRUE;
						return;
					}
				}
			}

			if (self.enemy.ammo_nails == 0)
			{
				if (random() < 0.5)
				{
					self.objective = self.enemy;
					if (random() < 0.5)
						self.spotfree = TRUE;
				}
				else
				{
					self.objective = findgoodshot();
					if (random() < 0.5)
						self.spotfree = TRUE;
				}
			}
			else if (random() < 0.1)
			{
				self.objective = self.enemy;
				if (random() < 0.5)
					self.spotfree = TRUE;
			}
		}
		else
		{
			makevectors(self.enemy.v_angle);
			traceline(self.enemy.origin, self.enemy.origin + v_forward * 1000, FALSE, self.enemy);
			
			if (trace_ent == self)
			{
				if (voice_time < time)
				{
					ent = findradius(self.origin, 500);
					oldself = world;
					while(ent)
					{
						if ((ent.classname == "monster_trooper") && (ent != self))
							oldself = ent;

						ent = ent.chain;
					}
					
					if (oldself != world)
					{
						speak (self, CHAN_VOICE, "voices/takecover.wav", 1, ATTN_IDLE);
						voice_time = time + 5 + (random() * 3);
					}
				}
				self.objective = findcover();
			}
			else
			{
				self.objective = findgoodshot();
				if ((!visible(self.enemy)) && (random() < 0.5))
					self.spotfree = TRUE;
			}
		}
	}
};

void() soldier_flinch =
{
	local float flo;

	if (!self.pain_type)
	{
		if (self.fire_type == 3)
			self.pain_type = ANIM_CROUCHPAIN;
		else
		{
			self.weapon_drawn = FALSE;

			flo = floor(random() * 3) + 1;

			if (flo == 1)
				self.pain_type = ANIM_STANDPAIN1;
			else if (flo == 1)
				self.pain_type = ANIM_STANDPAIN2;
			else 
				self.pain_type = ANIM_STANDPAIN3;
		}
	}
	if (animate_single(self.pain_type))
	{
		self.think = soldier_think;
		self.pain_type = 0;
	}
	
	self.nextthink = time + 0.1;
};

void(entity attacker, float howmuch) soldier_pain =
{
	local float flo;

	danger(self.origin, 100, 10, 5);

	if (self.pain_finished > time)
		return;
	
	self.pain_finished = time + 2;

	flo = random();

	if (flo < 0.45)
		speak (self, CHAN_VOICE, "voices/pain1.wav", 1, ATTN_IDLE);
	else if (flo < 0.9)
		speak (self, CHAN_VOICE, "voices/pain2.wav", 1, ATTN_IDLE);
	else
		speak (self, CHAN_VOICE, "voices/pain3.wav", 1, ATTN_IDLE);

	flo = random();

	if (!self.enemy)
		flo = flo * 2;

	if (attacker.classname == "player")
		self.enemy = attacker;
	
	if (self.health < 25)
	{
		self.objective = findcover();
		return;
	}

	if (flo > 0.5)
	{
		self.goalentity = world;
		self.objective = world;
		self.fire_time = time + 1 + random() * 2;
	}
	else if (flo > 0.25)
		self.objective = findcover();
	else if (flo < 0.05)
	{
		self.think = soldier_flinch;
		self.nextthink = time + 0.1;
	}
};

void() footstep =
{
	float ran, vol;

	ran = floor(random() * 4) + 1;
	vol = 0.25 + random() * 0.5;

	if (ran == 1)
		sound (self, CHAN_BODY, "steps/step1.wav", vol, ATTN_STATIC);
	else if (ran == 2)
		sound (self, CHAN_BODY, "steps/step2.wav", vol, ATTN_STATIC);
	else if (ran == 3)
		sound (self, CHAN_BODY, "steps/step3.wav", vol, ATTN_STATIC);
	else if (ran == 4)
		sound (self, CHAN_BODY, "steps/step4.wav", vol, ATTN_STATIC);
};

void() soldier_think =
{
	local float flo;

	self.think = soldier_think;
	self.nextthink = time + 0.1;
	
	if (!anim_setup)
		animation_setup();

	if (self.health < 33)
		self.skin = 2;
	else if (self.health < 66)
		self.skin = 1;

	if (!self.enemy)
	{
		if (random() < 0.1)
			self.enemy = FindEnemy();
		if (self.enemy)
		{
			self.fire_time = time + 1 + random() * 2;
			self.weapon_drawn = FALSE;
			self.fire_type = 0;
			self.spotfree = FALSE;
			self.strafing = FALSE;
		}
	}
	
	if (self.enemy)
		combat_ai();

	if (self.goalentity)
	{
		if (((self.spotfree) || (random() < 0.1))  && (visible(self.enemy)))
		{
			if ((voice_time < time) && (self.spotfree))
			{				
				flo = random();

				if (vlen(self.enemy.origin - self.origin) < 400)
				{
					if (flo < 0.5)
						speak (self, CHAN_VOICE, "voices/here1.wav", 1, ATTN_IDLE);
					else
						speak (self, CHAN_VOICE, "voices/here2.wav", 1, ATTN_IDLE);
	
				}		
				else
				{
					if (flo < 0.33)
						speak (self, CHAN_VOICE, "voices/overthere.wav", 1, ATTN_IDLE);
					else if (flo < 0.66)
						speak (self, CHAN_VOICE, "voices/thereheis.wav", 1, ATTN_IDLE);
					else 
						speak (self, CHAN_VOICE, "voices/spotted.wav", 1, ATTN_IDLE);
				}

				voice_time = time + 5 + (3 * random());
			}

			self.goalentity = world;
			self.objective = world;
			self.fire_time = time + 1 + random() * 2;
			self.weapon_drawn = FALSE;
			self.fire_type = 0;
			self.spotfree = FALSE;
			self.strafing = FALSE;

		}
		else if (vlen(self.origin - self.goalentity.origin) < 100)
		{
			self.goalentity = world;
			if ((voice_time < time) && (self.spotfree))
			{
				traceline(self.origin, self.enemy.origin, FALSE, world);

				flo = random();

				if (trace_ent.classname == "misc_crate")
				{
					if (flo < 0.5)
						speak (self, CHAN_VOICE, "voices/crate1.wav", 1, ATTN_IDLE);	
					else
						speak (self, CHAN_VOICE, "voices/crate2.wav", 1, ATTN_IDLE);	
				}
				else if (flo < 0.33)
					speak (self, CHAN_VOICE, "voices/where1.wav", 1, ATTN_IDLE);
				else if (flo < 0.66)
					speak (self, CHAN_VOICE, "voices/where2.wav", 1, ATTN_IDLE);
				else 
					speak (self, CHAN_VOICE, "voices/where3.wav", 1, ATTN_IDLE);

				voice_time = time + 5 + (3 * random());
			}
		}
		else
		{
			t_movetogoal(self.speed);
			animate_loop(ANIM_RUN);
			if ((self.animframe == 3) || (self.animframe == 7))
				footstep();
			return;
		}
	}
	if (self.objective)
	{
		if (vlen(self.origin - self.objective.origin) < 100)
		{
			self.objective = world;
			self.fire_time = time + 1 + random() * 2;
			self.weapon_drawn = FALSE;
			self.fire_type = 0;
			self.spotfree = FALSE;
			self.strafing = FALSE;
		}
		else	
		{
			self.fire_type = 0;
			self.goalentity = a_star();

			if (!saferoute)
			{
				self.goalentity = world;
				self.objective = world;
				self.fire_time = time + 1 + random() * 2;
				self.weapon_drawn = FALSE;
				self.fire_type = 0;
				self.spotfree = FALSE;
				self.strafing = FALSE;
				animate_loop(ANIM_STAND);
				return;
			}
			else if (self.goalentity == world)
			{
				self.objective = world;
			}
			else if (self.goalentity == self)
			{
				self.goalentity = world;
			}		
			else
			{
				animate_loop(ANIM_RUN);
				if ((self.animframe == 3) || (self.animframe == 7))
					footstep();
				return;
			}
		}
	}

	if (!self.enemy)
	{
		animate_loop(ANIM_STAND);
	}
};

void() soldier_die =
{
	local float flo;
	local entity ent;

	self.solid = SOLID_NOT;
if (self.health < -15)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_guard.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	self.health = 0;
	self.takedamage = DAMAGE_NO;
	self.classname = "dead";
	
	if (!self.death_type)
	{
		danger(self.origin, 200, 100, 30);
		
		flo = floor(random() * 3) + 1;

		if (flo == 1)
			speak (self, CHAN_VOICE, "voices/death1.wav", 1, ATTN_IDLE);
		else if (flo == 1)
			speak (self, CHAN_VOICE, "voices/death2.wav", 1, ATTN_IDLE);
		else
			speak (self, CHAN_VOICE, "voices/death3.wav", 1, ATTN_IDLE);

		if (self.fire_type == 3)
			self.death_type = ANIM_CROUCHDIE + 1;
		else
			self.death_type = floor(random() * 3) + 2;
	}

	if (!animate_single(self.death_type - 1))
	{
		self.think = soldier_die;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.think = SUB_Null;
		self.nextthink = time + 1;
	}
};

void() monster_trooper =
{	

	precache_model ("progs/soldier.mdl");

	precache_sound("voices/ammo.wav");
	precache_sound("voices/covering.wav");
	precache_sound("voices/coverme.wav");
	precache_sound("voices/death1.wav");
	precache_sound("voices/death2.wav");
	precache_sound("voices/death3.wav");
	precache_sound("voices/firehole.wav");
	precache_sound("voices/gethim.wav");
	precache_sound("voices/openfire.wav");
	precache_sound("voices/overthere.wav");
	precache_sound("voices/pain1.wav");
	precache_sound("voices/pain2.wav");
	precache_sound("voices/pain3.wav");
	precache_sound("voices/reload.wav");
	precache_sound("voices/runninglow.wav");
	precache_sound("voices/takecover.wav");
	precache_sound("voices/thereheis.wav");
	precache_sound("voices/spotted.wav");
	precache_sound("voices/here1.wav");
	precache_sound("voices/here2.wav");
	precache_sound("voices/crate1.wav");
	precache_sound("voices/crate2.wav");
	precache_sound("voices/where1.wav");
	precache_sound("voices/where2.wav");
	precache_sound("voices/where3.wav");	

	precache_sound("weapons/bullet1.wav");
	precache_sound("weapons/bullet2.wav");
	precache_sound("weapons/bullet3.wav");
	precache_sound("weapons/bullet4.wav");

	precache_sound("steps/step1.wav");
	precache_sound("steps/step2.wav");
	precache_sound("steps/step3.wav");
	precache_sound("steps/step4.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	setorigin(self, self.origin + '0 0 32');
	droptofloor();

	self.takedamage = DAMAGE_YES;
	self.health = 15;
	self.th_die = soldier_die;
	self.th_pain = soldier_pain;

	self.speed = 20;
	self.ammo_nails = 30;
	self.yaw_speed = 45;

	self.think = soldier_think;
	self.nextthink = time + 1;
};