// Crap that flies out of dave's mouth






void(entity hum) StateOfGibbing = {
	local string quip;
	local float eur;
	if (hum.gibcounting < 1)
		return; // no gibs, no state
	eur = random() * 20;

	if (random() < 0.2 * hum.gibcounting){
		
		if (eur < 1) quip = "voice/dave/gib/1.wav";
		else if (eur < 2) quip = "voice/dave/gib/2.wav";
		else if (eur < 3) quip = "voice/dave/gib/2.wav";
		else if (eur < 4) quip = "voice/dave/gib/2.wav";
		else if (eur < 5) quip = "voice/dave/gib/2.wav";
		else if (eur < 6) quip = "voice/dave/gib/2.wav";
		else if (eur < 7) quip = "voice/dave/gib/3.wav";
		else if (eur < 8) quip = "voice/dave/gib/3.wav";
		else if (eur < 9) quip = "voice/dave/gib/3.wav";
		else if (eur < 10) quip = "voice/dave/gib/3.wav";
		else if (eur < 11) quip = "voice/dave/gib/3.wav";
		else if (eur < 12) quip = "voice/dave/gib/3.wav";
		else if (eur < 13) quip = "voice/dave/gib/3.wav";
		else if (eur < 14) quip = "voice/dave/gib/4.wav";
		else if (eur < 15) quip = "voice/dave/gib/4.wav";
		else if (eur < 16) quip = "voice/dave/gib/4.wav";
		else if (eur < 17) quip = "voice/dave/gib/4.wav";
		else if (eur < 18) quip = "voice/dave/gib/4.wav";
		else if (eur < 19) quip = "voice/dave/gib/4.wav";
		else if (eur < 20) quip = "voice/dave/gib/4.wav";
		sound (hum,CHAN_VOICE,quip, 1, ATTN_NORM);
		hum.gibcounting = 0; // reset.
			}






};