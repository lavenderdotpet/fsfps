/*

    Copyright (C) 2008  Joe Kennedy

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "wav.h"

int main(int argc, char *argv[])
{
	// arguments
	if(argc > 1)
	{
		wav_t *wav = loadWav(argv[1]);

		// No wave, bugger off.
		if(!wav)
			return 0;

		// Output info on wave
		printWav(wav);

		// If we have an output file
		if(argc > 2)
			saveVoc(wav, argv[2]);

		// Free memory
		freeWav(wav);
	}

	// no arguments
	if(argc == 1)
	{
		printf("%s INPUT.WAV [OUTPUT.VOC]\n", argv[0]);
		puts(" - Giving only an input file will just display information about the wave.");
		puts(" - Giving input and output will convert the wav to a \n   creative .voc file of the given name.");
	}
	return 0;
}
