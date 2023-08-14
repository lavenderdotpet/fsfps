// Muzzleflashes

// fun fact: they're a vwep OF the vwep!
void() ColorFadeDown =
{
	self.colormod_x = self.colormod_x - 0.12;
	self.colormod_y = self.colormod_y - 0.16;
	self.colormod_z = self.colormod_z - 0.23;
	self.alpha = self.alpha - 0.07;
	self.scale = self.scale + 0.02;
	self.pflags = 0;
	self.nextthink = time + 0.01;
	self.think = ColorFadeDown;
	if (self.alpha < 0.04)
		remove(self);
};

void() MgunColorFadeDown =
{
	self.colormod_x = self.colormod_x - 0.12;
	self.colormod_y = self.colormod_y - 0.13;
	self.colormod_z = self.colormod_z - 0.21;
	self.alpha = self.alpha - 0.04;
	self.scale = self.scale - 0.07;
	self.pflags = 0;
	self.nextthink = time + 0.01;
	self.think = MgunColorFadeDown;
	if (self.alpha < 0.04)
		remove(self);
};

void(entity dumb, float tayep) DoFlashNow =
{
	// tayep = type of muzzleflash
	// dumb = the entity getting it's temporary vwep 
	// (DO NOT USE ON PLAYER ENTITIES - ONLY THE WEAPONS!)
	local vector there;
	dumb.vwep = spawn();
	dumb.vwep.movetype = MOVETYPE_NOCLIP;
	//setmodel(dumb.vwep, "models/fx/flash_sg.md3");
setmodel(dumb.vwep, "models/fx/flash.md3");

	
	dumb.vwep.think = ColorFadeDown; // todo - convincing fade
	dumb.vwep.nextthink = time + 0.03;
	dumb.vwep.scale = 0.34;
	dumb.vwep.alpha = 1;
	dumb.vwep.colormod = '1 1 1';
	dumb.vwep.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_CORONA;
	dumb.vwep.color = '3 2.3 1';
	dumb.vwep.light_lev = 118;
	dumb.vwep.angles_z = random() * 1000;
	if (tayep == 1){
setmodel(dumb.vwep, "models/fx/flash_mg.md3");
	dumb.vwep.scale = 0.4;
setattachment(dumb.vwep, dumb.fpwep, "tag_mgflash1"); // the first tag is typically the flash

	}
	if (tayep == 2){
setmodel(dumb.vwep, "models/fx/flash_sg.md3");
	dumb.vwep.scale = 0.4;
dumb.vwep.light_lev = 348;
	}
	if (tayep == 3){
setmodel(dumb.vwep, "models/fx/flash_rf.md3");
	dumb.vwep.scale = 0.47;
setattachment(dumb.vwep, dumb, "tag_rifflash");
there = gettaginfo(dumb.vwep, 1);
pointparticles(particleeffectnum("TE_GUNSMOKE"),there, '0 0 0', 1); // smoke it down wimp
	dumb.vwep.think = MgunColorFadeDown;
	}
	else
	{
setattachment(dumb.vwep, dumb, "tag_pisflash"); // the first tag is typically the flash
	there = gettaginfo(dumb.vwep, 1);
	pointparticles(particleeffectnum("TE_GUNSMOKE"),there, '0 0 0', 1); // smoke it down wimp
	// DO SMOKE
	}
		
};