float waydown;
float waynumber;
.float waynum;
.float lk1;
.float lk2;
.float lk3;
.float lk4;
.float lk5;
.float lk6;
.entity link1;
.entity link2;
.entity link3;
.entity link4;
.entity link5;
.entity link6;
float enteditor;
.float edtime;
.entity waypicked;
.float grouptog;
.float waytagged;
.float waydist;
float prelinked;

.float fcost;
.float gcost;
.float hcost;
.float waycost;

.entity startnode;
.entity endnode;
.float waylist;
.entity wayparent;
.entity stacknext;
.entity bookedent;

float WAY_EMPTY = 0;
float WAY_OPEN = 1;
float WAY_CLOSED = 2;

float wpframe;

.float crouching;
.entity weapon_model;

.entity objective;
.float weapon_drawn;
.float fire_time;
.float fire_type;
.float spotfree;
.float reloading;
.float death_type;
.float pain_type;
float foundcover;
float saferoute;

float grenade_time;
.float grenade_throw;
float voice_time;
.float strafing;

float anim_setup;
.float animframe;
.float lastanim;

float ANIM_CROUCHDIE = 0;	// Crouch death
float ANIM_STANDDIE1 = 1;	// Stand death thrown backwards
float ANIM_STANDDIE2 = 2;	// Stand death turn over;
float ANIM_STANDDIE3 = 3;	// Stand death drop flat
float ANIM_CROUCHPAIN = 4;	// Crouch pain
float ANIM_STANDPAIN1 = 5;	// Stand pain 1
float ANIM_STANDPAIN2 = 6;	// Stand pain 2
float ANIM_STANDPAIN3 = 7;	// Stand pain 3
float ANIM_MELEE = 8;		// Melee
float ANIM_RELOAD = 9;		// Reload
float ANIM_GRENADE = 10;	// Grenade
float ANIM_HIPDRAW = 11;	// Draw hip
float ANIM_HIPFIRE = 12;	// Fire hip
float ANIM_AIMDRAW = 13;	// Draw aim
float ANIM_AIMFIRE = 14;	// Fire aim
float ANIM_CROUCHDRAW = 15;	// Draw crouch
float ANIM_CROUCHFIRE = 16;	// Fire crouch
float ANIM_LEFTFIRE = 17;	// Left strafe fire
float ANIM_RIGHTFIRE = 18;	// Right strafe fire
float ANIM_RUN = 19;		// Run
float ANIM_WALK = 20;		// Walk
float ANIM_STAND = 21;		// Stand

float animation_frames_0;
float animation_frames_1;
float animation_frames_2;
float animation_frames_3;
float animation_frames_4;
float animation_frames_5;
float animation_frames_6;
float animation_frames_7;
float animation_frames_8;
float animation_frames_9;
float animation_frames_10;
float animation_frames_11;
float animation_frames_12;
float animation_frames_13;
float animation_frames_14;
float animation_frames_15;
float animation_frames_16;
float animation_frames_17;
float animation_frames_18;
float animation_frames_19;
float animation_frames_20;
float animation_frames_21;

float animation_start_0;
float animation_start_1;
float animation_start_2;
float animation_start_3;
float animation_start_4;
float animation_start_5;
float animation_start_6;
float animation_start_7;
float animation_start_8;
float animation_start_9;
float animation_start_10;
float animation_start_11;
float animation_start_12;
float animation_start_13;
float animation_start_14;
float animation_start_15;
float animation_start_16;
float animation_start_17;
float animation_start_18;
float animation_start_19;
float animation_start_20;
float animation_start_21;