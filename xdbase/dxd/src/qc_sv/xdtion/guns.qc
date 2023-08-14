// Davexd weaponry

void() XDV_Precache =
{

	precache_sound ("misc/foot1.wav");	// machinegun
	precache_sound ("misc/foot2.wav");
	precache_sound ("misc/foot3.wav");
	precache_sound ("misc/foot4.wav");

	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/rocketl/fire.wav");
	precache_sound ("weapons/rocketl/load.wav");
	precache_sound ("weapons/rocketl/draw.wav");
	precache_sound ("weapons/grenadel/boom.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/mgun.wav");	// machinegun
	precache_sound ("weapons/mgun2.wav");	// machinegun
	precache_sound ("weapons/shotgun.wav");	// shotgun
	precache_sound ("weapons/pistol.wav");	// pistol
	precache_sound ("weapons/clipin.wav");	// pistol
	precache_sound ("weapons/swap.wav");	// pistol

};

void() XDV_DefineModel =
{

	if (self.weapon == IT_SHOTGUN)
		setmodel(self.fpwep,"models/weapons/v_beretta.dpm");
	else if (self.weapon == IT_SUPER_SHOTGUN)
		setmodel(self.fpwep,"models/char/david/arm2/beagle.md3");
//	else if (self.weapon == IT_NAILGUN)
	//	setmodel(self.fpwep,"models/char/david/arm/mgun.md3");
	else if (self.weapon == IT_NAILGUN)
		setmodel(self.fpwep,"models/char/david/arm2/rifle.md3");
	else
		setmodel(self.fpwep,"models/char/david/arm/arms.md3");

go_anim(self.fpwep, 0, 0, 3, 0);

};

void() XDV_Shotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/shotgun.wav", 1, ATTN_NORM);	

	//self.punchangle_x = -4;
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireBullets (12, dir, '0.08 0.04 0'); // TODO: real
if (self.fpwep){DoFlashNow(self.fpwep, 2);	go_anim(self.fpwep, 1, 24, 0.07, 0);}
};

void() XDV_Machinegun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/mgun.wav", 1, ATTN_NORM);	

	//self.punchangle_x = -4;
	
	//self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	bullet (1, dir, '0.05 0.02 0', 7); // TODO: spread
if (self.fpwep){DoFlashNow(self.fpwep, 3);	go_anim(self.fpwep, 1, 6, 0.05, 0);}
};
void() VW_KeepSpinDown;
// faster more inaccurate firing
void() XDV_Machinegun2 =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/mgun2.wav", 1, ATTN_NORM);	

	//self.punchangle_x = -4;
	
	//self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	bullet (1, dir, '0.08 0.08 0', 7); // TODO: spread
if (self.fpwep){DoFlashNow(self.fpwep, 3);	go_anim(self.fpwep, 15, 45, 0.07, 0);
	

}

};



void() XDV_MachinegunSwitch =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/swap.wav", 1, ATTN_NORM);	
if (self.mgunmode){
if (self.fpwep.fpwep){go_anim(self.fpwep, 19, 8, 0.05, 0);
go_anim(self.fpwep.fpwep, 0, 12, 0.05, 0);}
self.mgunmode = 0;

		}
	else
	{
	self.mgunmode = 1;
if (self.fpwep.fpwep){	go_anim(self.fpwep, 8, 19, 0.05, 0);
go_anim(self.fpwep.fpwep, 12, 0, 0.05, 0);}
	}
};

void() XDV_Pistol =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "beretta/fire.wav", 1, ATTN_NORM);	

	//self.punchangle_x = -4;
			self.attack_finished = time + 0.2;
	//self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	bullet (1, dir, '0.05 0.02 0', 9); // TODO: spread
if (self.fpwep){DoFlashNow(self.fpwep, 0);	go_anim(self.fpwep, 1, 1, 3, 0);}
self.clip_pistol = self.clip_pistol + 1;
if (self.clip_pistol > 10)
	{
	if (self.fpwep){	go_anim(self.fpwep, 3, 3, 3, 0);}	
	self.attack_finished = time + 1.3;
	sound (self, CHAN_AUTO, "weapons/clipin.wav", 1, ATTN_NORM);	
	self.clip_pistol = 0;
	}
};


void() XDV_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
//	self.show_hostile = time + 1;	

	if (self.weapon == IT_AXE)
	{
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		XDV_Pistol ();

	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{

		XDV_Shotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
	if (self.mgunmode){
	XDV_Machinegun2 ();
	self.attack_finished = time + 0.07;
		}
	else
		{	
	XDV_Machinegun ();
	self.attack_finished = time + 0.1;
		}
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
	
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{

		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
	
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
	
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
};


void() XDV_AttackII =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity

	 if (self.weapon == IT_SHOTGUN)
	{
		
	// TODO: Toggle Laser Sight or Fire Flare?
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{

	
	}
	else if (self.weapon == IT_NAILGUN)
	{
	XDV_MachinegunSwitch ();
	self.attack_finished = time + 0.6;
	}
	
};


