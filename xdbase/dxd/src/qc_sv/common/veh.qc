/*  Copyright (C) 2008  leileilol

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

void() DeathOfAVehicle;
// VEHICLE CODE the meat and stuff!!
void(float thrusty)ThrustTowardsThrust;
// I tried to simplify. :(
// I am trying to have instead, a player attach to the tag_eyes of the vehicle md3
// rather than the old fashioned qtank-style morph-the-player-into-the-vehicle
// crap (no offense Singe)

void() ThrustVehicle =
{
	local vector thrst;
	if (!self.mount)
		return; // no vehicle to thrust!!
	{
	//makevectors (self.mount.v_angle); // vehicle's angle please
	//makevectors (self.v_angle); // driver's angle please
	makevectors (self.mount.angles); // vehicle angle


	// Momentumness please
	self.thrust = aim(self.mount, 10000);
//	self.thrust_y = self.thrust_x;
//	self.thrust_x = 0; // retarded switch
//	self.thrust = self.thrust * 1600;
//	self.thrust_z = self.thrust_z + 45;
//	self.thrust_z = 25;

// blue smoke stuff lol
	//pointparticles(particleeffectnum("TE_BLUEENGINE"), self.mount.engine1.origin, self.mount.velocity * -1, 1);
	pointparticles(particleeffectnum("TE_GUNSHOT"),gettaginfo(self.mount,gettagindex(self.mount,"tag_eng1")), self.mount.velocity * -1, 1);
	pointparticles(particleeffectnum("TE_GUNSHOT"),gettaginfo(self.mount,gettagindex(self.mount,"tag_eng2")), self.mount.velocity * -1, 1);
	//pointparticles(particleeffectnum("TE_BLUEENGINE"), self.mount.engine2.origin, self.mount.velocity * -1, 1);

//	self.mount.velocity = self.mount.velocity + (self.thrust * 0.2);
//Gyro_Object_SetThrust(self.mount, 700); // reset thrust
	ThrustTowardsThrust(168);
	if (self.mount.gyro_object_thrust < 13)
		self.mount.t_width = time + 0.03;
	}

};

void() VehicleEngineNoise =
{
	//RapidNoise("engines/a2.wav", 0.8);
	//RapidNoise("engines/a3.wav", 0.8);
	//RapidNoise("engines/a4.wav", 0.8);
	//RapidNoise("engines/a5.wav", 0.8);
//if (self.driver.thrust)
	//RapidNoise("engines/a6.wav", 0.8);
//else
	//RapidNoise("engines/a1.wav", 0.8);

	if (self.gyro_object_thrust > 13)
	RapidNoise("engines/a6.wav", 0.8);
	else if (self.gyro_object_thrust > 11)
	RapidNoise("engines/a5.wav", 0.8);
	else if (self.gyro_object_thrust > 9)
	RapidNoise("engines/a4.wav", 0.8);
	else if (self.gyro_object_thrust > 7)
	RapidNoise("engines/a3.wav", 0.8);
	else if (self.gyro_object_thrust > 5)
	RapidNoise("engines/a2.wav", 0.8);
	else if (self.gyro_object_thrust > 2)
	RapidNoise("engines/a2.wav", 0.8);
	else
	RapidNoise("engines/a1.wav", 0.8);

//if (self.driver){
//	sprint(self.driver, ftos(self.gyro_object_thrust));
//	sprint(self.driver, "\n");
//	}

};

void(entity targ, vector newangle)TurnTowardsAngle;
void(entity targ, vector newangle)TurnTowardsAngle2;
void(entity targ, vector newangle)TurnTowardsAngle3;
void() VehicleThink;
void() VehicleThink =
{
	VehicleEngineNoise(); // make some loud noises
	//bprint("im thinking!\n");
	self.think = VehicleThink;
	self.nextthink = time + 0.02;
//	TurnTowardsAngle2(self, self.driver.angles);
	TurnTowardsAngle3(self, self.driver.angles);

	Gyro_Object_SetThrust(self, 0); // reset thrust
if (self.health < 1)
	DeathOfAVehicle();
};

void() VehicleBoom =
{
	local float	damg;
	local vector fuddle;
	local float ouchen = 100;
	fuddle = self.origin;
	fuddle_x = fuddle_x + (random() * ouchen - (ouchen * 0.5));
	fuddle_y = fuddle_y + (random() * ouchen - (ouchen * 0.5));
	fuddle_z = fuddle_z + (random() * ouchen - (ouchen * 0.5));

	T_RadiusDamage (self, self.owner, 78, other);

	sound (self, CHAN_WEAPON, "weapons/xcar.wav", 1, 0.3);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, fuddle_x);
	WriteCoord (MSG_BROADCAST, fuddle_y);
	WriteCoord (MSG_BROADCAST, fuddle_z);
	pointparticles(particleeffectnum("TE_CHUNKS_SPARKS"), fuddle, '0 0 0', 32);
	pointparticles(particleeffectnum("TE_CHUNKS_DEBRIS"), fuddle, '0 0 0', 32);

	local entity	force;
	force = Gyro_Force_Create("bigexplosion", fuddle);
	Gyro_Force_ApplyFalloff_AreaLinear(force, '1 1 1' * 345);
	Gyro_Force_ApplyAffector_Point(force, '0 0 -16', '1 1 1', 86, FALSE);
	Gyro_Force_AddProperty_Instant(force);
};

void() SuperBoom =
{
	local float	damg;

	T_RadiusDamage (self, self.owner, 177, other);

	sound (self, CHAN_WEAPON, "weapons/xcar.wav", 1, 0.2);
	pointparticles(particleeffectnum("TE_BIGBOOM"), self.origin, '0 0 0', 3);
	pointparticles(particleeffectnum("TE_CHUNKS_SPARKS"), self.origin, '0 0 0', 122);
	pointparticles(particleeffectnum("TE_CHUNKS_DEBRIS"), self.origin, '0 0 0', 74);
	local entity	force;
	force = Gyro_Force_Create("bigexplosion", self.origin);
	Gyro_Force_ApplyFalloff_AreaLinear(force, '1 1 1' * 445);
	Gyro_Force_ApplyAffector_Point(force, '0 0 -16', '1 1 1', 222, FALSE);
	Gyro_Force_AddProperty_Instant(force);
};



void(float whichway) TurnVehicle =
{
	local vector thrst;
	if (!self.mount)
		return; // no vehicle to thrust!!
	{
	makevectors (self.mount.v_angle); // vehicle's angle please

	// Momentumness please
	//thrst = thrst * v_right * whichway;
	
	self.mount.avelocity = self.mount.avelocity + thrst;
	}

};

// Mount vehicles in this
void() vehicle_touch =
{
	if (self.driver)
		return; // No thanks, I have a driver don't hijack
	if (other.classname == "player")
	{
	other.mount = self; // Get 'em in
	self.driver = other; // They're driver
	self.flags = FL_MONSTER; // attract bot hack
	//bprint(other.driver);
	// Debug messages
	bprint(other.netname);
	bprint(" mounting ");
	bprint(self.classname);
	bprint(" vehicle\n");	

	// Keep the player in the seat
	//	setattachment(other,self,"tag_eyes");

	// Make eyes, 
		if (!self.eyeeye)
			self.eyeeye=spawn();
	// put eyes in the appropriate position of vehicle
		self.eyeeye.owner = self;
		setattachment(self.eyeeye,self,"tag_seat");
		setmodel (self.eyeeye, "models/driver.md3"); // make a driver
	// mount player's vision to these 'eyes'
  		msg_entity = self.driver;
		WriteByte (MSG_ONE, SVC_SETVIEWPORT);  
		WriteEntity (MSG_ONE, self.eyeeye);           
	}
};


// Unmount vehicles in this
void(entity getout) Dismount =
{
	// Debug messages
	bprint(getout.netname);
	bprint(" dismounting ");
	bprint(getout.mount.classname);
	bprint(" vehicle\n");	
	getout.origin = getout.mount.origin + '20 0 245';
	getout.velocity_z = 4521;
	getout.orphan = 1;
	getout.movetype = MOVETYPE_WALK;
	getout.mount = world; // TODO: forget about vehicle
//	other.driver = self.nullhack; 
	msg_entity = getout;                      
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);  
	WriteEntity (MSG_ONE, getout);  
	sound (getout, CHAN_BODY, "player/bail.wav", 1, 0.4);
};


// Defined vehicles

// Test vehicle
// Weapons:
//  0 - minigun
//  1 - special beam cannon
//  2 - twin rockets
//  3 - mortar

void() info_vehicle1 =
{	
	precache_model ("models/vehicles/test/vehicle.md3");
	
	self.flags = FL_ITEM; // attract bot hack
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_YES;
	//self.movetype = MOVETYPE_STEP;
	self.movetype = MOVETYPE_WALK; // vehicle traction and such

	setmodel (self, "models/vehicles/test/vehicle.md3");

//	setsize (self, '-16 -16 -24', '16 16 40');
	setsize (self, '-64 -64 -16', '64 64 80');

	self.health = 10;
	self.touch = vehicle_touch; // unmounted by default
	self.think = VehicleThink;
	self.ammo = 400;
	self.ammo_max = self.ammo;
	self.th_die = DeathOfAVehicle;
	self.gun1 = WEP_MACHINEGUN;
	self.gun2 = WEP_ROCKET;
	self.gun3 = WEP_BEAM;
	self.gun4 = WEP_MORTAR;	
	self.gun5 = WEP_MACHINEGUN;
	self.engine1 = spawn();
	self.engine2 = spawn();
	setattachment(self.engine1,self,"tag_eng1");
	setattachment(self.engine2,self,"tag_eng2");
	setmodel(self.engine1,"models/nothing.md3");
	setmodel(self.engine2,"models/nothing.md3");
	self.material = MAT_METAL;
	VehicleThink();

// Gyro!
	Gyro_Object_Activate(self, 200);
	Gyro_Object_SetHover(self,566, 135, 133); // get it hoverin'
	Gyro_Object_SetBouyancy(self, 1270*0.6);
	Gyro_Object_SetResistance(self, 200*0.4);
//	Gyro_Object_SetAerodynamics(self, 200*0.8);


};


// I ripped this function out of my on-hold Hentai Game


float(float coord)FixAngleCoord =
{
	if(coord > 180)
		return -360 + coord;
	
	if(coord < -180)
		return 360 + coord;
	
	return coord;
};

void(entity targ, vector newangle)TurnTowardsAngle =
{
	if(targ.angles == newangle)
		return;		
	
	if(vlen(targ.angles - newangle) < 0.1) // snap to angle
		targ.angles = newangle;
	else
		targ.angles = targ.angles + (newangle - targ.angles)*0.1; // turn speed
};

// for yaw only

// Limit player's pitch and yaw turning for the vehicle
void(entity targ, vector newangle)TurnTowardsAngle2 =
{
	local vector argh; 
	local vector moveit;
	if(targ.angles == newangle)
		return;	
	{	
	//bprint("Angle: ");
//	bprint(ftos(targ.angles_y));
	//bprint(" - Trying to turn to ");
//	bprint(ftos(newangle_y));
	//bprint("\n");
	}
//	if (targ.angles_y > 360)
//		targ.angles_y = 0; // spin fix
//	if (targ.angles_y < 0)
//		targ.angles_y = 360; // spin fix
//	if (newangle_y < -180)	
//		newangle_y = newangle_y * -1; // wheops	

// TODO: FIX THE TURNING!!!
	
	//argh = newangle;
	//argh_y = argh_y - targ.angles_y;

	//bprint("Argh_y = ");
	//bprint(ftos(argh_y));
	//bprint("\n");
	moveit_y = newangle_y - targ.angles_y;
		while( moveit_y > 180 ) 
			moveit_y -= 360;
		while( moveit_y < -180 ) 
			moveit_y += 360;
		//targ.angles_y = targ.angles_y + (newangle_y - targ.angles_y)*0.03; // turn speed
		targ.angles_y = targ.angles_y + (moveit_y * 0.03 ); 
		targ.angles_x = targ.angles_x + (newangle_x - targ.angles_x)* 0.05; // turn speed
};



void(entity targ, vector newangle)TurnTowardsAngle3 =
{
	local vector argh; 
	local vector moveit;
	if(targ.angles == newangle)
		return;	
	{	
	bprint("Angle: ");
	bprint(ftos(targ.angles_y));
	bprint(" - Trying to turn to ");
	bprint(ftos(newangle_y));
	bprint("\n");
	}
//	if (targ.angles_y > 360)
//		targ.angles_y = 0; // spin fix
//	if (targ.angles_y < 0)
//		targ.angles_y = 360; // spin fix
//	if (newangle_y < -180)	
//		newangle_y = newangle_y * -1; // wheops	

// TODO: FIX THE TURNING!!!
	
	//argh = newangle;
	//argh_y = argh_y - targ.angles_y;

	//bprint("Argh_y = ");
	//bprint(ftos(argh_y));
	//bprint("\n");
	moveit_y = newangle_y - targ.angles_y;
		while( moveit_y > 180 ) 
			moveit_y -= 360;
		while( moveit_y < -180 ) 
			moveit_y += 360;
		//targ.angles_y = targ.angles_y + (newangle_y - targ.angles_y)*0.03; // turn speed
		targ.angles_y = targ.angles_y + (moveit_y * 0.03 ); 
		targ.angles_x = targ.angles_x + (newangle_x - targ.angles_x)* 0.05; // turn speed
};

void(float thrusty)ThrustTowardsThrust =
{
	local float thrasht;
// smooth out the actual thrusting
		// thrast = thrast + (thrusty - thrast)*0.05; 
	self.thrast = self.thrast + (thrusty - self.thrast * 0.05); // 
Gyro_Object_SetThrust(self.mount, self.thrast); // reset thrust

};
void() ExplodeAgain =
{
	self.multiboom = self.multiboom + 1;
	if (self.multiboom > 5){
		SuperBoom(); // final boom
		remove(self); // no more vehicle.
	}
	VehicleBoom(); // more boom

	self.think = ExplodeAgain;
	self.nextthink = time + 0.5 + (random() * 2.6);

};

void() DeathOfAVehicle =
{
	// dismount any player
	if (self.driver){
	Dismount(self.driver);
		}
	self.movetype = MOVETYPE_BOUNCE;
	Gyro_Object_RemoveHover(self); // STOP HOVERING
	VehicleBoom(); // first boom
	Gyro_Object_SetAerodynamics(self, 450*0.8); // get flippin'
	self.think = ExplodeAgain;
	self.nextthink = time + 0.01;

// Burn!
	self.modelflags = MF_TRACER;
};