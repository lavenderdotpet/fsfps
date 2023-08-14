void() barrel_burning =
{

	precache_model ("models/props/barrelburn.md3");

	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_TOSS;

	setmodel (self, "models/props/barrelburn.md3");
	setorigin(self, self.origin + '0 0 800');
	self.gravity = 0.3;
	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 25;
/*
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
*/
	//walkmonster_start();
	//go_anim(self,0, 20, 0.03, 1);
	self.effects = EF_FLAME;
	self.color = '1 0.75 0.4';
	self.pflags = PFLAGS_CORONA | PFLAGS_FULLDYNAMIC;
};

void() effect_smogking =
{

	precache_model ("models/props/smoking.md3");


	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;

	setmodel (self, "models/props/smoking.md3");
	//	setmodel (self, "models/props/barrelburn.md3");
	self.avelocity = '2 3 3';
	self.scale = 6;
};
