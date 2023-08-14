void() vehicle_boaet =
{

	precache_model ("models/vehicle/boat/boat.md3");

	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_TOSS;

	setmodel (self, "models/vehicle/boat/boat.md3");
	setorigin(self, self.origin + '0 0 800');
	self.gravity = 0.3;
	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 254;
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

};


void() vehicle_boat =
{	
	precache_model ("models/vehicle/boat/boat.md3");
	
	self.flags = FL_ITEM; // attract bot hack
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_YES;
//self.movetype = MOVETYPE_STEP;
	self.movetype = MOVETYPE_WALK; // vehicle traction and such

	setmodel (self, "models/vehicle/boat/boat.md3");

//	setsize (self, '-16 -16 -24', '16 16 40');
	setsize (self, '-64 -64 -16', '64 64 80');

	self.health = 7;
	self.touch = vehicle_touch; // unmounted by default
	self.think = VehicleThink;
	self.th_die = DeathOfAVehicle;
	self.material = MAT_METAL;
//	VehicleThink();

// Gyro!
	Gyro_Object_Activate(self, 200);
	Gyro_Object_SetHover(self,566, 135, 133); // get it hoverin'
	Gyro_Object_SetBouyancy(self, 1270*0.9);
	Gyro_Object_SetResistance(self, 200*0.4);
	Gyro_Object_SetAerodynamics(self, 200*0.8);
/*
	Gyro_Object_Activate(self, 560);
	Gyro_Object_SetHover(self,16, 16, 13); // get it hoverin'
	Gyro_Object_SetBouyancy(self, 7576);
	Gyro_Object_SetResistance(self, 760*0.4);
	Gyro_Object_SetAerodynamics(self, 600*0.8);
*/


};

