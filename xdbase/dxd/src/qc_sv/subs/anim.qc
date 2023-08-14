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

// ANIMATION SUBROUTINES
//
// Purely existing to
// 1. make life easier
// 1a. get working first
// 2. csqcize later
// LEILEIS HACKY ANIMATION THING 
.float seq_start; // start of remote anim sequence
.float seq_end; // end of remote anim sequence
.float seq_rate; // rate of remote anim sequence
.float seq_loop; // is looping?

// i shouldnt put a function here, but anyway here we go
void() GOFRAM =
{
		if (self.seq_start < self.seq_end){ self.frame = self.frame + 1;
				if (self.frame > self.seq_end)
			{
			if (self.seq_loop)
				self.frame = self.seq_start;
			else if (self.seq_loop == 451)
				remove(self);		// special loop 451 destroys it
							// for stupid sprite effects
			else
				self.frame = self.seq_end;
			return;
			}	
			}
		else 
		{ self.frame = self.frame - 1; // reverse operation
		if (self.frame < self.seq_end)
			{
			if (self.seq_loop)
				self.frame = self.seq_start;
			else if (self.seq_loop == 451)
				remove(self);		// special loop 451 destroys it
							// for stupid sprite effects
			else
				self.frame = self.seq_end;
			return;
			}

		}
		self.think = GOFRAM;
		self.nextthink = time + self.seq_rate; 
};

void(entity that, float st, float en, float rt, float lp) go_anim =
{
		that.seq_start = st;
		that.seq_end = en;
		that.seq_rate = rt;
		that.seq_loop = lp;

		that.frame = st; // start from the specified frame
		that.think = GOFRAM;
		that.nextthink = time + that.seq_rate; 


// WOW WHAT A HACK!
};

