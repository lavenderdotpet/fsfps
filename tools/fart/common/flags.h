/*

    Copyright (C) 2007  Joe Kennedy

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


#ifndef FART_FLAGS_H
#define FART_FLAGS_H

#include "bmp.h"

struct flag_s
{
    int speed;
    int numframes;
    int animtype;
    int xoffset;
    int yoffset;
    char *imagename;
};

typedef struct flag_s flag_t;

flag_t *flags;

int numtiles;
int tilestart;

int readFlags(char *filename);
void writeFlags(art_t *art, char *filename);

#endif
