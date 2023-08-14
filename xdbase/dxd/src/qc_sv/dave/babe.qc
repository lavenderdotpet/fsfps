void() innocent_babe =
{
//	if (deathmatch)
//	{
//		remove(self);
//		return;
//	}
	precache_model ("models/char/babe/babe.md3");

	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/char/babe/babe.md3");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;
/*
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
*/
	//walkmonster_start();
	go_anim(self,0, 20, 0.03, 1);
};
void() Dance =
{
	go_anim(self, 0, 35, 0.03, 0);
	self.think = Dance;
	self.nextthink = time + 1;
};

void() monster_trofr =
{
//	if (deathmatch)
//	{
//		remove(self);
//		return;
//	}
	precache_model ("models/char/babe/babe.md3");

	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;

	setmodel (self, "models/char/babe/babe.md3");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;
/*
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
*/
	//walkmonster_start();
	Dance();
	self.think = Dance;
	self.nextthink = time;
};

void() barrel_explode =
{
//	if (deathmatch)
//	{
//		remove(self);
//		return;
//	}
	precache_model ("models/char/neko/dressy.md3");

	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "models/char/neko/dressy.md3");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;
/*
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
*/
	//walkmonster_start();
	self.scale = 1.61;
	//go_anim(self,0, 20, 0.03, 1);
};
