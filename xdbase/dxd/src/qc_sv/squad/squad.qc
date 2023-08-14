.string s_model;
float() crandom;
//void() player_reload;

void() Call_Guy = 
{
	local entity ent, ent2;

	ent2 = spawn();
	setorigin(ent2, self.origin);

	ent = find(world, classname, "monster_trooper");
	
	while(ent)
	{
		ent.enemy = self;
		ent = find(ent, classname, "monster_trooper");
	}
};

void() misc_crate =
{
	precache_model("progs/crate.md3");
	setmodel(self, "progs/crate.md3");
	self.solid = SOLID_BSP;
	setsize(self, '-64 -64 -24', '64 64 40');
	self.origin = self.origin + '0 0 24';
	droptofloor();
};

void() flame_flicker =
{
	local vector vec;

	vec = self.oldorigin;
	vec_x = vec_x + crandom() * 3;
	vec_y = vec_y + crandom() * 3;
	vec_z = vec_z + crandom() * 2;
	
	setorigin(self, vec);

	self.nextthink = time + 0.1;
};

void() light_barrel =
{
	local entity ent, ent2;
	local vector vec;
	
	precache_model("progs/barrel.mdl");
	precache_model("progs/nothing.mdl");
	precache_model("progs/fire.mdl");
	setmodel(self, "progs/barrel.mdl");
	self.solid = SOLID_BSP;
//	setsize(self, '-32 -32 -24', '32 32 40');
	self.origin = self.origin + '0 0 24';
	droptofloor();

	ent = spawn();
	setmodel(ent, "progs/nothing.mdl");
	setorigin(ent, self.origin + '0 0 8');
	ent.oldorigin = ent.origin;
	ent.glow_color = 110;
	ent.glow_size = 200;
	ent.think = flame_flicker;
	ent.nextthink = time + 0.1;

	ent2 = spawn();
	setmodel(ent2, "progs/fire.mdl");
	ent.movetype = MOVETYPE_NOCLIP;
	setorigin(ent2, self.origin - '0 0 7');
	ent2.avelocity_y = crandom() * 50;
	ent2.effects = EF_NOSHADOW + EF_ADDITIVE;
};

void() misc_scenery =
{
	local entity ent;
	
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;
        precache_model (self.s_model);
        setmodel (self, self.s_model);

	self.origin_z = self.origin_z + 2;
	droptofloor();

	ent = spawn();
	makevectors(self.angles);
	setmodel(ent, "progs/nothing.mdl");
	setorigin(ent, self.origin + '0 0 95' + v_forward * 16 + v_right * -3);
	ent.glow_color = 252;
	ent.glow_size = 100;
};

void() crouchtoggle =
{
	self.crouching = 1 - self.crouching;

	if (self.crouching)
	{
		setsize(self, VEC_HULL_MIN, '16 16 16');
//		self.view_ofs = '0 0 10';
	}
	else
	{
		setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
//		self.view_ofs = '0 0 22';
	}
};

float() Squad_Stuff =
{
	wpframe = FALSE;
	if (!waydown)
	{
		waydown = TRUE;
		Editor_Load();
		waypoint_autolink(); 
	}

	if (self.weapon_model)
		self.weapon_model.frame = self.weaponframe;

	if (self.impulse == 11)
	{
		self.grouptog = TRUE;
		self.impulse = 0;
	}
	if (self.impulse == 12)
	{
		self.grouptog = FALSE;
		self.impulse = 0;
	}
	if (self.impulse == 13)
	{
		Entity_Editor_Toggle();
		self.impulse = 0;
	}
	if (self.impulse == 14)
	{
		Editor_Save();
		self.impulse = 0;
	}
	if (self.impulse == 15)
	{
		Editor_Load();
		self.impulse = 0;
	}
	if (self.impulse == 16)
	{
		Call_Guy();
		self.impulse = 0;
	}
	if (self.impulse == 17)
	{
//		player_reload();
		self.impulse = 0;
	}
	if (self.impulse == 18)
	{
		crouchtoggle();
//		bprint(vtos(self.origin));
//		bprint("\n");
		self.impulse = 0;
	}

	if (self.crouching)
	{
		if (self.flags & FL_ONGROUND)
			if (vlen(self.velocity) > 100)
				self.velocity = normalize(self.velocity) * 100;
		
		if (self.view_ofs_z > 10)
			self.view_ofs_z = self.view_ofs_z - (50 * frametime);
	}
	else if (self.view_ofs_z < 22)
		self.view_ofs_z = self.view_ofs_z + (50 * frametime);

	if (self.view_ofs_z < 10)
		self.view_ofs_z = 10;
	if (self.view_ofs_z > 22)
		self.view_ofs_z = 22;


	if (enteditor)
		Entity_Editor();

	if (self.attack_finished < time)
	{
		if (self.button0)
		{
			if (enteditor)
			{	
				Editor_Click();
				self.attack_finished = time + 0.25;
				return TRUE;
			}
		}
	
		if (self.button2)
		{
			if (enteditor)
			{
				Editor_Rightclick();
				self.attack_finished = time + 0.25;
				return TRUE;
			}
		}
	}
	return FALSE;
};