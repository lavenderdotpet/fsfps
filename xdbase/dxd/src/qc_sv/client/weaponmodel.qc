// View model entity.

void () VW_BarrelAction;

// Create a fpwep entity for the player if she has none
void() VW_MakeAfpwep =
{
	self.fpwep = spawn();
	self.fpwep.owner = self;
	self.fpwep.viewmodelforclient = self;
	
	// okay it's done sir.
};


// Checking and setting.
void () VW_CheckIfIGotsView =
{

	if (!self.fpwep)
		{
		VW_MakeAfpwep();
		return;
		}


	if (self.weapon == IT_SHOTGUN)
		setmodel(self.fpwep,"models/char/david/arm2/beagle.md3");
	else if (self.weapon == IT_SUPER_SHOTGUN)
		setmodel(self.fpwep,"models/char/david/arm2/beagle.md3");
//	else if (self.weapon == IT_NAILGUN)
	//	setmodel(self.fpwep,"models/char/david/arm/mgun.md3");
	else if (self.weapon == IT_NAILGUN)
		setmodel(self.fpwep,"models/char/david/arm2/rifle.md3");
	else
		setmodel(self.fpwep,"models/char/david/arm/arms.md3");
	//VW_BarrelAction();
};


// Create a fpwep entity for the player if she has none
void() VW_MakeABarrel =
{
/*	self.fpwep.fpwep = spawn();
	self.fpwep.fpwep.owner = self;
	self.fpwep.viewmodelforclient = self;
	self.fpwep.fpwep.scale = 1.5;
	self.fpwep.movetype = MOVETYPE_NOCLIP;
*/
};
// spin down gun
void() VW_KeepSpinDown =
{
	if (self.frame > 0)
		{
			GOFRAM();
			return;
		}
	self.avelocity = self.avelocity * 0.9;
	self.think = VW_KeepSpinDown;
	self.nextthink = time + 0.03;
};
// Some weapons have spinny stuff too
void () VW_BarrelAction =
{
/*
	if (!self.fpwep.fpwep)
		{
		VW_MakeABarrel();
		return;
		}


	if (self.weapon == IT_NAILGUN){
		setmodel(self.fpwep.fpwep,"models/char/david/arm/mgunbarrel.md3");
		self.fpwep.fpwep.effects = 0;
	setattachment(self.fpwep.fpwep, self.fpwep, "tag_barrel");
		}
	else
		self.fpwep.fpwep.effects = EF_NODRAW;
*/
};