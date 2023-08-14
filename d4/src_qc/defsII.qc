// new defs

float DWEAPONFRAME = 9; // default weapon frame

.entity wpsv; // Weaponframe animation server, to offload weaponframe setting to instead of player frames
		// (independent, faster weapon animations)

float setting_detail; // 0 - no fluff entities, 1 - some fluff entities, 2 - all fluff entities

float violence; // variety of server-side violence setting
		// 5 - Blood, gibs, extra gibs, pain skins (if detail is set)
		// 4 - Blood, gibs, pain skins
		// 3 - Blood with pain skins
		// 2 - Minimal blood 
		// 1 - No blood
		// 0 - Corpses 'poof' away instead of falling to the ground

float lowrate = 0; // Forces low weapon framerate 

.float wpfm; // old style weaponframe, when server isn't available (low fi weapon anims friendly for 486s)
float   EF_ADDITIVE     = 32; // for flares in dp ! and software maybe.
.float gravity;

.float button4;
.float button5;
.float button6;
.float button7;
.float button8;
.float oldweapon; // for the switch