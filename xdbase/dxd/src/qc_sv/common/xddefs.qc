/*
  Copyright (C) 2007-2009  xdfort team

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

// XDBASE New Defs

// The Player
.vector offsez; // height adjustment for playing on tfc maps (taller), or q3f/qwtf maps (shorter)

//      '0 0 0' - qwtf
//	'0 0 26'  - tfc
.float screamplayed; // have we screamed from falling already? set 0 if not, set 1 if falling.
.string plyrmdl; // Player model to choose (hard coded?)

.entity vwep; // third person view wepaon
.entity fpwep; // first person view weapon
.entity fparm; // first person view arms, that hold the weapon, and throw the grenades
.float released; // released the fire button for semi-automatic weaponry that doesn't exist.

// The cosmetics of the player
.entity hair1; // fringe hair (IN FRONT OF THE EYES)
.entity hair2; // cranial hair (THE BULK OF IT)
.entity hair3; // additional hair (STUFF LIKE LOCKS) (NOTE: May not be used?)
.entity glasses; 
.entity eyes; // eyes ! (may hack in 'view from real eyes' fun server cvar later)
.entity mouth; // mouth, independent entity of animated speaking and cuteness
.float style; // style of any of the above.
.float bodtype; // body type, 0 for weak, 1 for medium, 2 for tough, 3 for buxom (female only)
.float sex; // 0 for male, 1 for female

float MAX_HAIR_1 = 2; // max hair fringes
float MAX_HAIR_2 = 2; // max hair to choose from
float MAX_HAIR_3 = 2; // max hair
float MAX_GLASSES = 2; // max hair fringes
float MAX_MOUTH = 2; // max mouths
float MAX_EYES = 2; // max eyes
float MAX_EARS = 2; // max ears



// The game
.float class; // official class



// The weapons
/*
// Moved to subs/anim.qc

.float seq_start; // start of remote anim sequence
.float seq_end; // end of remote anim sequence
.float seq_rate; // rate of remote anim sequence
.float seq_loop; // is looping?

*/

.float ammo_in_rl;
float MAX_CLIP_ROCKET = 4;  // how much a rocket launcher can hold!


.float footcyc; // foot cycle.

.float gibcounting; // player gib kill control (for automatic quotes)