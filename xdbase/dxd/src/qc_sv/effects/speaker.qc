// SPEAKERS n' THINGS

void() target_speaker =
{
	precache_sound (self.noise);
	ambientsound (self.origin, self.noise, 1, ATTN_STATIC);
};


// Lei - psuedo loop noise
void(string noise, float duration) RapidNoise =
{

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, noise, 1, ATTN_NORM);
		self.t_width = time + duration;
	}

};
