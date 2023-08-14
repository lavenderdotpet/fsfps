// because boobs look cooler in red/blue
void() ravelight =
{
	self.movetype = MOVETYPE_FLY;
	self.avelocity = '666 0 666';
	self.pflags = PFLAGS_FULLDYNAMIC;
	self.skin = 22;
	self.light_lev = 1240;
	
};


void() StupidFlashFade;
void() StupidFlashFade =
{
// stupid!
	if (self.frame > 12){
		remove(self);
		}
	self.frame = self.frame + 1;
	self.alpha = self.alpha - 0.2;
	self.scale = self.scale + 0.7;
	self.think = StupidFlashFade;
	self.nextthink = time + 0.03;
};

void(entity owned, string tgname) QuickFlash =
{
	local entity frash;
	if (!owned.fpweap)
		return;
	frash = spawn();

		{
		frash.effects = EF_ADDITIVE | EF_FULLBRIGHT;
		setmodel(frash,"models/flash.md3");
		setattachment(frash, owned.fpweap, tgname);
		
		frash.alpha = 1;
		frash.scale = 2;
		//frash.think = StupidFlashFade;
		frash.think = SUB_Remove;

		frash.angles_z = random() * 503;
		frash.nextthink = time + 0.04;
		}
};

