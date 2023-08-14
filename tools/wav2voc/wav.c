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

// readword_le
// - read little endian word into big endian int
int readword_le(FILE *fp, int wordsize)
{
	int i;
	int total = 0;

	for(i = 0; i < wordsize; i++)
	{
		total |= fgetc(fp) << (i << 3);
	}

	return total;
}

// writeword_le
// - write little endian word from big endian int
void writeword_le(FILE *fp, int wordsize, int value)
{
	int i;

	for(i = 0; i < wordsize; i++)
	{
		fputc((value & (0xFF << (i << 3))) >> (i << 3), fp);
	}
}


// loadWav
// - load necessary bits of a wav into our nice struct
wav_t *loadWav(char *filename)
{
	wav_t *newwav;

	char buffer[5];
	buffer[4] = NULL;

	FILE *fp;
	fp = fopen(filename, "rb");

	// I AM ERROR
	if(!fp)
	{
		perror(filename);
		return NULL;
	}

	// Allocate us some memory
	newwav = malloc(sizeof(wav_t));

	// Check we have a wave file
	fread(buffer, 1, 4, fp);
	if(strcmp(buffer, "RIFF"))
	{
		free(newwav);
		printf("%s: is not a wav file.\n", filename);
		return NULL;
	}

	// Get the chunk length	
	newwav->chunk_length = readword_le(fp, 4);

	// Check we have a wave file
	fread(buffer, 1, 4, fp);
	if(strcmp(buffer, "WAVE"))
	{
		free(newwav);
		printf("%s: is not a wav file.\n", filename);
		return NULL;
	}

	// Wheeee
	fseek(fp, 22, SEEK_SET);
	newwav->num_channels = readword_le(fp, 2);
	newwav->sample_rate = readword_le(fp, 4);
	newwav->bytes_per_second = readword_le(fp, 4);
	newwav->bytes_per_sample = readword_le(fp, 2);
	newwav->bits_per_sample = readword_le(fp, 2);

	// seek into the data chunk
	fseek(fp, 40, SEEK_SET);
	newwav->data_length = readword_le(fp, 4);

	// and get our data
	newwav->data = malloc(newwav->bytes_per_sample * newwav->data_length);
	fread(newwav->data, newwav->bytes_per_sample, newwav->data_length, fp);
	
	// then store away the filename for later use
	newwav->filename = strdup(filename);

	fclose(fp);
	return newwav;
}

// saveVoc(wav_t *wav)
// - save wav to Creative voc format - changes sample rate to 11025hz and makes sounds 8bit
void saveVoc(wav_t *wav, char *filename)
{
	FILE *fp = fopen(filename, "wb");

	// HEADER
	// - check out voc specs for more in depth, no point here
	fwrite("Creative Voice File", strlen("Creative Voice File"), 1, fp);
	fputc(0x1A, fp);
	fputc(0x1A, fp);
	fputc(0x00, fp);
	fputc(0x0A, fp);
	fputc(0x01, fp);
	fputc(0x29, fp);
	fputc(0x11, fp);

	// DATA BLOCK INFO
	fputc(0x01, fp);

	// the block size is from the (original data length / bits per sample) / (original sample rate / target sample rate)
	// basically scaling the length depending on how many bytes/what frequency the old data was at
	int block_size = (int)((float)wav->data_length / (float)wav->bytes_per_sample) / ((float)wav->sample_rate / 11025.0);
	float ratemul = ceil(wav->sample_rate / 10989.0);
	writeword_le(fp, 3, block_size);

	fputc(165, fp);	// frequency divisor (check out some voc specifications)
	fputc(0, fp);	// codec id (0 == 8 bits unencoded)

	// Data
	int i, j, k, tmp;
	float value;
	for(i = 0; i < block_size; i++)
	{
		value = 0.0;

		// get samples (can be more than 1 byte in size) 
		for(j = 0; j < wav->bytes_per_sample/wav->num_channels; j++)
		{		
			value += (float)(wav->data[(int)(i * ratemul * wav->bytes_per_sample) + j] << (j << 3));
		}

		// sort out 16bit samples
		if(wav->bits_per_sample == 16)
			value = (((value + 32768.0) / 65536.0) * 256.0);
		
		fputc((int)value, fp);
	}

	fputc(0, fp);	// TERMINATOR	
	fclose(fp);

	printf("Wrote %s at 11025hz and 8 bits per sample.\n", filename);
}

// printWav
// - print wav info
void printWav(wav_t *wav)
{
	printf("Filename: %s\n", wav->filename);
	printf("| Chunk Length: %d\n", wav->chunk_length);
	printf("| Num Channels: %d\n", wav->num_channels);
	printf("| Sample Rate: %d\n", wav->sample_rate);
	printf("| Bytes Per Second: %d\n", wav->bytes_per_second);
	printf("| Bytes Per Sample: %d\n", wav->bytes_per_sample);
	printf("| Bits Per Sample: %d\n", wav->bits_per_sample);
	printf("| Data Length: %d\n", wav->data_length);
}

// freeWav
// - free wav from memory (if exists)
void freeWav(wav_t *wav)
{
	if(wav)
	{
		if(wav->filename)
			free(wav->filename);

		if(wav->data)
			free(wav->data);

		free(wav);
	}
}
