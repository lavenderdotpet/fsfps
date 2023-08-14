

// Footsteps

void(float pos, float vol) Footstep =
{
        local   entity tehsound;

        tehsound = spawn ();
        tehsound.movetype = MOVETYPE_NONE;
	makevectors (self.v_angle);

        setorigin (tehsound, self.origin + v_right*pos + '0 0 -16'); 

   // Do the footstep noise
        if (!self.waterlevel){
               if (self.footcyc == 1) sound (tehsound, CHAN_BODY, "misc/foot1.wav", vol, ATTN_NORM);
               else if (self.footcyc == 2) sound (tehsound, CHAN_BODY, "misc/foot2.wav", vol, ATTN_NORM);
               else if (self.footcyc == 3) sound (tehsound, CHAN_BODY, "misc/foot3.wav", vol, ATTN_NORM);
              else sound (tehsound, CHAN_BODY, "misc/foot4.wav", vol, ATTN_NORM);
	       }

   // Do sloshy noise
        if (self.waterlevel == 1){
                sound (tehsound, CHAN_BODY, "misc/footwater1.wav", vol, ATTN_NORM);

        // Make a particle for more realism
                particle (tehsound.origin, '0 0 5', 42, 15);

              }
	self.footcyc = self.footcyc + 1;
	if (self.footcyc > 3) self.footcyc = 0;
        remove(tehsound);
};