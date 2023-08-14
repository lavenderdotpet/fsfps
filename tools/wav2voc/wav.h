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

#ifndef WAV2VOC_WAV_H
#define WAV2VOC_WAV_H

#include "stdio.h"

struct wav_s
{
	char *filename;
	int chunk_length;

	int num_channels;
	int sample_rate;
	int bytes_per_second;
	int bytes_per_sample;
	int bits_per_sample;

	int data_length;
	char *data;
};
typedef struct wav_s wav_t;

void saveVoc(wav_t *wav, char *filename);

int readword_le(FILE *fp, int wordsize);
wav_t *loadWav(char *filename);
void printWav(wav_t *wav);
void freeWav(wav_t *wav);

#endif
