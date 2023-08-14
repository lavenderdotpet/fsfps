
/*  
------------------------------------------------------------------------
	Fired Guns
	by Lei-Lei

	wp_lasr.qc
	If it involves a flying projectile it goes here!
------------------------------------------------------------------------
*/

// LASERS AND ARROWS

// Adopted the NetQuake infront AI function for the knife, so we can get back kills.
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};

// tweaked function for more narrow knife kill
float(entity targ) knifeinfront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.01)
	{
		return TRUE;
	}
	return FALSE;
};


// ARROW(ed)S!
// when an arrow sometimes bounces off the wall and hits a player it kills them with a
// cosmetic funny bonus.
void() AccidentalArrowTouch =
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
		spawn_touchblood ((100 * self.arrstrength));
		other.deathtype = "accident arrow";
		T_Damage (other, self, self.owner, (60 * self.arrstrength));
	}
	else
	{
		remove(self);
	}

	remove(self);

};


void() T_ArrowTouch =
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
		spawn_touchblood ((100 * self.arrstrength));
		other.deathtype = "arrow";
		T_Damage (other, self, self.owner, (60 * self.arrstrength));
		sound (self, CHAN_WEAPON, "fired/flesh.wav", 1, ATTN_NORM);
		remove(self); // get out of here arrow !
		return;
	}
	else
	{
		if (random() < 0.5){
		sound (self, CHAN_WEAPON, "fired/arrhit.wav", 1, ATTN_NORM);

			self.movetype = MOVETYPE_NONE;
			self.velocity = '0 0 0'; // "stick"
			self.nextthink = time + 10;
			self.think = SUB_Remove;
			}
		else
			{
		sound (self, CHAN_WEAPON, "fired/bigload.wav", 1, ATTN_NORM);
			// fling somewhere, hopefully hitting some morons!
			self.movetype = MOVETYPE_BOUNCE;
			self.avelocity_x = random() * 2000 - 1000;
			self.avelocity_y = random() * 2000 - 1000;
			self.avelocity_z = random() * 2000 - 1000;
	self.velocity_x = self.velocity_x + (random() * 400 - 200);
	self.velocity_y = self.velocity_y + (random() * 400 - 200);
	self.velocity_z = self.velocity_z + (random() * 400 - 200);

			self.touch = AccidentalArrowTouch;
			self.nextthink = time + 3;
			self.think = SUB_Remove;
			}
	}


};


void() W_FireArrow =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	
	sound (self, CHAN_WEAPON, "fired/bow.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * (1675 * self.arrstrength);
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_ArrowTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 10;
	newmis.think = SUB_Remove;
	newmis.classname = "rocket";
	newmis.gravity = 0.5;
	setmodel (newmis, "progs/fired/arrow.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
	newmis.arrstrength = self.arrstrength; // yes we're still gonna use the values
};

// THROWING KNIFES
// kinda like arrows, but only fatal to the back

void() T_KnifeTouch =
{
local float rand;

// back stabiin stuff
	local float g;
	local entity moran;
	moran = self;
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
		spawn_touchblood ((100 * self.arrstrength));
		other.deathtype = "knife";

// TODO: Make back kills do very high damage
if (other.health > 0 && other.solid != SOLID_BSP) {
		self = other;
		g = knifeinfront(moran);
		//bprint (PRINT_HIGH,ftos(g));
		self = moran;
				if (g){
	T_Damage (other, self, self.owner, (2 * self.arrstrength));
		//centerprint(self.owner,"Back totally missed :(\n");
		}
		else if (g == 0){
		T_Damage (other, self, self.owner, (340 * self.arrstrength));
		//centerprint(self.owner,"BACK IS HIT!\nEXCELLENT THROW\n");
		}
		sound (self, CHAN_WEAPON, "fired/knifed.wav", 1, ATTN_NORM);
		remove(self); // get out of here knife!
		return;
		}
	}
	else
	{
		sound (self, CHAN_WEAPON, "fired/arrhit.wav", 1, ATTN_NORM);

			self.movetype = MOVETYPE_NONE;
			self.velocity = '0 0 0'; // "stick"
			self.nextthink = time + 10;
			self.think = SUB_Remove;
	}


};


void() W_ThrowKnife =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	
	sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);

//	msg_entity = self;
//	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * (1000 * self.arrstrength);
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_KnifeTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 10;
	newmis.think = SUB_Remove;
	newmis.classname = "rocket";
	newmis.gravity = 0.8;
	newmis.avelocity = '600 0 0'; // flip flip flip
	setmodel (newmis, "progs/fired/knife2.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
	newmis.arrstrength = self.arrstrength; // yes we're still gonna use the values
};




// Dummy

void() monster_army =
{	
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/player.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 3444440;

	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.th_die = SUB_Null;
	self.takedamage = DAMAGE_YES;
	//walkmonster_start ();
};


// PLASMA GUN!
// standard 'projectile with cool effect', for now.

void() T_PlasmaTouch =
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
		spawn_touchblood (35);
		other.deathtype = "plasma";
		T_Damage (other, self, self.owner, 35);
		self.frame = 0;
		self.velocity = '0 0 0';
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.frame = 0;
		self.velocity = '0 0 0';
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}

	// remove(self);

};

void() W_FirePlasma =
{
	if (deathmatch != 4)
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	
	sound (self, CHAN_WEAPON, "fired/plasma.wav", 1, ATTN_NORM);

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_BLUE; // glow blue for GL users
		
// set newmis speed     

	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 800;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_PlasmaTouch;
	newmis.voided = 0;
	
// set newmis duration
	newmis.nextthink = time + 7;
	newmis.think = SUB_Remove;
	newmis.classname = "plasma";

	setmodel (newmis, "progs/fired/fx.spr");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 20' + v_right*12);
	newmis.avelocity_x = 5442;
	newmis.avelocity_y = 5442;
	newmis.avelocity_z = 5442;
	newmis.frame = 2;
};
